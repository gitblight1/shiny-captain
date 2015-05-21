shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Pythagorean Win calculator"),
    sidebarPanel(
      selectInput('team', 'Select a team',
                  choices = unique(Teams$name[order(Teams$name)]),
                  selected = 'Detroit Tigers'),
      numericInput('year', 'Select a year',
                   value = 1984, min = 1901, max = 2013, step = 1),
      actionButton('yrAction', 'Calculate!')
      ),
    mainPanel(
       h3('Results'),
#       h4('You entered'),
#       verbatimTextOutput("team"),
#       h4('Which resulted in a prediction of '),
       uiOutput("result")
    )
  )
)