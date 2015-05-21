library(Lahman)

shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Pythagorean Win Calculator"),
    sidebarPanel(
      selectInput('team', 'Select a team',
                  choices = unique(Teams$name[order(Teams$name)]),
                  selected = 'Detroit Tigers'),
      numericInput('year', 'Select a season',
                   value = 1984, min = 1901, max = 2013, step = 1),
      actionButton('yrAction', 'Calculate!'),
      withMathJax(
        helpText(HTML("Calculates <a href=\"https://en.wikipedia.org/wiki/Pythagorean_expectation\">pythagorean (expected) wins</a>"),
                 "for the selected baseball team and season (data exists through the 2013 season).",
                 "This is calculated using the formula",
                 "$$\\frac{(Runs)^a}{(Runs)^a + (Runs Allowed)^a}$$",
                 "where the exponent \\(a\\) is calculated using the",
                 HTML("'<a href=\"https://en.wikipedia.org/wiki/Pythagenpat\">Pythagenpat</a>' method."),
               "If you select a season where the selected team did not play, the",
               "selection box will be reset (in most cases) to the nearest season they did play."))
      ),
    mainPanel(
       h3('Results'),
       uiOutput("result")
    )
  )
)