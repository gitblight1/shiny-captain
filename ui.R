library(Lahman) # gotta include this here and in server.R

shinyUI(pageWithSidebar(
    # Application title
    headerPanel("Pythagorean Win Calculator"),
    # Input section
    sidebarPanel(
        selectInput(
            'team',
            'Select a team',
            choices = unique(Teams$name[order(Teams$name)]),
            selected = 'Detroit Tigers'
        ),
        selectInput(
            'year',
            'Select a season',
            selected = 1984,
            choices = seq(1901, 2015)
        ),
        #TODO add checkboxes for exponents here
        checkboxGroupInput(
            'exponent',
            'Select calculation methods:',
            c(
                "Original",
                "Baseball Reference",
                "Pythagenport",
                "Pythagenpat"
            )
        ),
        actionButton('yrAction', 'Calculate!'),
        
        withMathJax(
            helpText(
                HTML(
                    "Calculates <a href=\"https://en.wikipedia.org/wiki/Pythagorean_expectation\">pythagorean (expected) wins</a>"
                ),
                "for the selected baseball team and season (data exists through the 2013 season).",
                "This is calculated using the formula",
                "$$\\frac{(Runs)^a}{(Runs)^a + (Runs Allowed)^a}$$",
                "where the exponent \\(a\\) is calculated up to four different ways.",
                "Use the checkboxes to select the method(s) to calculate the exponent;",
                "each method is explained in the link above.",
                "If you select a season where the selected team did not play, the",
                "selection box will be reset to the nearest season they did play."
            )
        )
    ),
    # Output section
    mainPanel(h3('Results'),
              uiOutput("result"), # output is dynamically rendered in server.R
              tableOutput("data"))
))
