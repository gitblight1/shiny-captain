library(Lahman) # gotta load this here and in ui.R

# Calculate expected win percentage
pythagWpct <- function(rScored, rAllowed, games) {
  # Calculate the exponent using the 'Pythagenpat' method
  exponent = ((rScored + rAllowed)/games)^0.287
  
  rScored^exponent / (rScored^exponent + rAllowed^exponent)
}

# Format the output string and return it as an HTML element.
formatResult <- function(season) {
  pWpct = with(season, pythagWpct(R, RA, G))
  result = with(season, sprintf("In %d, the %s scored %d runs and allowed %d,
                   giving them an expected win percentage of %.3f
                   (expected record %d-%d).<br/>
                   Their actual record was %d-%d.",
                   yearID, name, R, RA, pWpct, round(G*pWpct,0),
                   G-round(G*pWpct,0), W, L))
  HTML(result)
}

shinyServer(
  function(input, output, session) {

    yrRng = reactive(
      # When a team is selected, get the first and last year they played
      range(Teams$yearID[Teams$name == input$team])
    )
    observe({
      # Update the valid year inputs based on yrRange. This only updates when
      # the Calculate button is pressed, and doesn't disallow years between two
      # different franchises with the same team name (e.g., the 1901 and
      # 1970-2013 versions of the Milwaukee Brewers). Perhaps a select box would
      # have been a better idea?
      input$yrAction
      isolate({
      minYr = yrRng()[1]
      maxYr = yrRng()[2]
      # if the current year is outside the range, reset it to the nearest end.
      curYr = min(maxYr, max(minYr, input$year))
      updateNumericInput(session, 'year',
                         value = curYr,
                         min = minYr,
                         max = maxYr)
      })
    })
    season <- reactive(
      # grab info about the season when a team and year are selected.
      Teams[Teams$name == input$team & Teams$yearID == input$year,]
    )

    # create the main result when the calculate button is clicked.
    output$result <- renderUI({
      input$yrAction
      isolate(formatResult(season()))
    })
  }
)