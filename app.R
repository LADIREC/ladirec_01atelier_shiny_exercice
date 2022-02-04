# Les donneés utilisées dans cet exercice proviennent de https://www.donneesquebec.ca/recherche/dataset/toponymes-officiels/resource/50ed47a8-51dd-4756-81b6-c8b67a0420f1#:~:text=Comprend%20les%20d%C3%A9cisions%20de%20la,Contient%20130%20637%20lignes.
# setwd("~/Dropbox/ShinyRomans@lireDashboard/2022AtelierShinyExercice")

if(!"shiny" %in% rownames(installed.packages())){install.packages("shiny")}
if(!"data.table" %in% rownames(installed.packages())){install.packages("data.table")}
if(!"ggplot2" %in% rownames(installed.packages())){install.packages("ggplot2")}

library(shiny)
library(data.table)
library(ggplot2)


###################### Exercices #####################

# Exécutez la ligne de code ci-dessous pour importer le jeu de données dans l'environnement.
toponymes <- fread("toponymes_officiels.csv")

# Observez la structure du jeu de données

str(toponymes)

# Observez le nombre de valeurs uniques des origines linguistiques
unique(toponymes$Origine_linguistique)

### Pouvez-vous remplacer par une variable (table de données) les astérisques dans la ligne de code ci-dessous? À quoi correspond le résultat?
# toponymes[Origine_linguistique %in% "***", .N]

### Indiquez à nouveau une valeur en remplacement des astérisques. Que se passe-t-il lorsque vous exécutez le code?
# x <- toponymes[Origine_linguistique %in% "***"]

### Si `x`est l'objet produit par la commande ci-dessus, que pourrait produire la commande ci-dessous, où `x`est fourni en entrée? 
# ggplot(x, aes(x=Origine_linguistique))+
#   geom_bar()+
#   coord_flip()

### Exécuter l'application ("Run App") et divisez votre fenêtre de travail en deux. D'un côté, placez l'application et, de l'autre observez le code ci-dessous.
### Pouvez-vous associer les blocs de code de l'objet `ui` à des éléments observables de l'application?
### Si, au lieu de l'origine linguistique, vous souhaitiez que l'application retrace la désignation du territoire associé à un toponyme, quels ajustements au code devraient être faits?

ui <- fluidPage(

    titlePanel("Toponymie officielle du Québec"),

    sidebarLayout(
        sidebarPanel(
          checkboxGroupInput(inputId = "choix_langues",
                             label = "Langue(s):",
                             choices = unique(toponymes$Origine_linguistique),
                             selected = c("Wendat", "Inuktitut",
                                          "Cri", "Innu",
                                          "Algonquin", "Abénaquis",
                                          "Mohawk", "Micmac",
                                          "Naskapis", "Attikamek",
                                          "Malécite"))
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
