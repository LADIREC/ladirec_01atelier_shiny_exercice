if(!"data.table" %in% rownames(installed.packages())){install.packages("data.table")}
library(shiny)
library(data.table)
library(ggplot2)

# Importation des données sous la forme d'une data.table
toponymes <- fread("toponymes_officiels.csv")
# str(toponymes)
# unique(toponymes$Origine_linguistique)


choix_langues <- c("Français", "Inuktitut")


ui <- fluidPage(

    # Titre de l'application
    titlePanel("Toponymie officielle du Québec"),

    # Bloc latéral où se fera le choix des langues 
    sidebarLayout(
        sidebarPanel(
          checkboxGroupInput(inputId = "choix_langues",
                             label = "Langue(s):",
                             choices = unique(toponymes$Origine_linguistique),
                             selected = c("Wendat", "Inuktitut",
                                          "Cri", "Innu",
                                          "Algonquin", "Abénaquis"))
        ),

        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Logique des opérations qui se font en arrière-plan
server <- function(input, output, session) {

    output$distPlot <- renderPlot({
      x <- toponymes[Origine_linguistique %in% input$choix_langues]

      ggplot(x, aes(x=Origine_linguistique))+
        geom_bar()+
        coord_flip()
    })
}

# Exécution de l'application
shinyApp(ui = ui, server = server)
