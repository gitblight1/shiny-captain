library(Lahman) # gotta load this here and in ui.R

# Calculate expected win percentage
pythagWpct <- function(rScored, rAllowed, exponent) {
    rScored ^ exponent / (rScored ^ exponent + rAllowed ^ exponent)
}

origExp <- 2

brExp <- 1.83

portExp <- function(rScored, rAllowed, games) {
    # Calculate the exponent using the 'Pythagenport' method
    exponent = 1.5 * log((rScored + rAllowed) / games, 10) + 0.45
}

patExp <- function(rScored, rAllowed, games) {
    # Calculate the exponent using the 'Pythagenpat' method
    exponent = ((rScored + rAllowed) / games) ^ 0.287
}

makeTable <- function(season) {
    rows = c('Original',
             'Baseball Reference',
             'Pythagenport',
             'Pythagenpat')
    expList = c(origExp,
                brExp,
                with(season, portExp(R, RA, G)),
                with(season, patExp(R, RA, G)))
    pWpct = with(season, pythagWpct(R, RA, expList))
    pythagRecord <-
        data.frame(
            'pct.' = pWpct,
            'Wins' = with(season, as.integer(round(G * pWpct, 0))),
            'Losses' = with(season, G - as.integer(round(G * pWpct, 0))),
            row.names = rows
        )
}

# Format the output string and return it as an HTML element.
formatResult <- function(season) {
    result = with(
        season,
        sprintf(
            "In %d, the %s scored %d runs and allowed %d in %d games.<br/>
            Their actual record was %d-%d, a win percentage of %.3f.<br/>
            Expected win percentage(s) and record(s):",
            yearID,
            name,
            R,
            RA,
            G,
            W,
            L,
            W/(W+L)
        )
    )
    HTML(result)
}

shinyServer(function(input, output, session) {
    yrRng = reactive(# When a team is selected, get the years they played
        sort(Teams$yearID[Teams$name == input$team]))
    observe({
        # Update the valid year inputs based on yrRange. This only updates when
        # the Calculate button is pressed, and should disallow years when the selected
        # franchise did not play.
        input$yrAction
        isolate({
            yrs = yrRng()
            # if the current year is outside the range, reset it to the nearest year in the range.
            curYr = yrs[which.min(abs(yrs - as.numeric(input$year)))]
            updateSelectInput(session,
                              'year',
                              choices = yrs,
                              selected = curYr)
        })
    })
    season <-
        reactive(# grab info about the season when a team and year are selected.
            Teams[Teams$name == input$team & Teams$yearID == input$year,])
    
    resultText <- eventReactive(input$yrAction, formatResult(season()))
    resultData <- eventReactive(input$yrAction, makeTable(season()))
#    resultCaveat <- eventReactive(input$yrAction, makeCaveat(season()))
    # create the main result when the calculate button is clicked.
    output$result <- renderUI(resultText())
    output$data <-renderTable(
        resultData()[input$exponent, , drop = FALSE], 
        rownames = TRUE,
        digits = 3
        )
})
