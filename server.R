library(Lahman)

pythagWpct <- function(rScored, rAllowed, games) {
  exponent = ((rScored + rAllowed)/games)^0.287
  rScored^exponent / (rScored^exponent + rAllowed^exponent)
}

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
      range(Teams$yearID[Teams$name == input$team])
    )
    observe({
      input$yrAction
      isolate({
      minYr = yrRng()[1]
      maxYr = yrRng()[2]
      curYr = min(maxYr, max(minYr, input$year))
      updateNumericInput(session, 'year',
                         value = curYr,
                         min = minYr,
                         max = maxYr)
      })
    })
    season <- reactive(
      Teams[Teams$name == input$team & Teams$yearID == input$year,]
    )

    output$result <- renderUI({
      input$yrAction
      isolate(formatResult(season()))
    })
  }
)