library(shiny)
library(shinythemes)
library(shinyWidgets)
library(Hmisc)
library(UsingR)
library(ggplot2)
library(reshape2)
library(rsconnect)
library(rpart)
library(rpart.plot)

pacotes = c("shiny", "shinydashboard", "shinythemes", "plotly", "shinycssloaders","tidyverse",
            "scales", "knitr", "kableExtra", "ggfortify","dplyr","plotly","FNN")


# Contenu de l'interface
ui <- fluidPage(
    # Titre de l'ui
    navbarPage("Exploration univarié et bivarié de datasets pour le module Accompagnement ", theme = shinytheme("flatly")),theme = shinytheme("flatly"),
    
    sidebarLayout(
        
        sidebarPanel(width= 3,
                     
                     fluidRow(
                         column(10, 
                                selectInput(inputId= "file1", label = "Choisir dataset", c("", "Insufisance cardiaque")), theme = shinytheme("flatly")
                         )
                     ),
                   
                     fluidRow( #, selected = 1
                         column(10, theme = shinytheme("flatly"),div(style = "height: +30px"),
                                #Radio boutton pour le choix de type d'exploration
                                prettyRadioButtons(inputId = "typeExploration", label= "Type d'exploration", thick = FALSE, bigger = FALSE, choices = c("Exploration univarié"= 1, "Exploration bivarié"= 2), animation = "pulse", 
                                                   status = "info")
                                
                                
                         )
                     ),
                     fluidRow(
                         column(10, theme = shinytheme("flatly"),div(style = "height: +10px"),
                                #liste deroulante pour le choix de attribut premier
                                selectInput(inputId= "Attribut1", label = "Variable x", c("age" = 1, "anaemia" = 2, "creatinine_phosphokinase" = 3, "diabetes" = 4, "ejection_fraction"=5, "high_blood_pressure"= 6, "platelets"=7, "serum_creatinine"=8, "serum_sodium"=9, "sex"= 10, "smoking"= 11, "time"= 12, "death_event"= 13)),
                                
                                conditionalPanel(
                                    
                                    condition = " input.typeExploration == 2 ", 
                                    # liste deroulante pour le choix de attribut deuxieme
                                    selectInput(inputId= "Attribut2", label = "Variable y", c("age" = 1, "anaemia" = 2, "creatinine_phosphokinase" = 3, "diabetes" = 4, "ejection_fraction"=5, "high_blood_pressure"= 6, "platelets"=7, "serum_creatinine"=8, "serum_sodium"=9, "sex"= 10, "smoking"= 11, "time"= 12, "death_event"= 13)) 
                                )
                                
                                
                         )
                     ),
                     
                     fluidRow(
                         column(4,  offset = 2, theme = shinytheme("flatly"),
                                #Confirmer le choix du type d'exploration et des attributs choisies
                                actionButton(inputId = "go", label="Voir les résultats")), 
                         
                         theme = shinytheme("flatly")
                     ),
                     
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Table / Statistiques ",
                         conditionalPanel(
                           condition = "input.typeExploration == 1 && ( input.Attribut1 == 1 || input.Attribut1 == 3 ||input.Attribut1 == 5 || input.Attribut1 == 7 || input.Attribut1 == 8 || input.Attribut1 == 9 ||  input.Attribut1 == 12 )", 
                             fluidRow(column(6,offset = 4, textOutput("titreCentreDisp") )),
                             fluidRow(column(6, offset=4,tableOutput("centreDisp"),theme = shinytheme("flatly")),theme = shinytheme("flatly"))
                         ),
                         # conditionalPanel(
                         #   condition = "input.typeExploration == 2 && ( input.Attribut1 == 1 || input.Attribut1 == 3 ||input.Attribut1 == 5 || input.Attribut1 == 7 || input.Attribut1 == 8 || input.Attribut1 == 9 ||  input.Attribut1 == 12 ) && ( input.Attribut2 == 2 || input.Attribut2 == 4 ||input.Attribut2 == 6 || input.Attribut2 == 10 || input.Attribut2 == 11 || input.Attribut2 == 13 )", 
                         #   fluidRow(column(6,offset = 4, textOutput("titreCentreDisp1") )),
                         #   fluidRow(column(6, offset=4,tableOutput("centreDisp1"),theme = shinytheme("flatly")),theme = shinytheme("flatly"))
                         # ),
                         conditionalPanel( # &&( input.Attribut1 == 1 || input.Attribut1 == 3 ||input.Attribut1 == 5 || input.Attribut1 == 7 || input.Attribut1 == 8 || input.Attribut1 == 9 ||  input.Attribut1 == 12 ) && ( input.Attribut2 == 1 || input.Attribut2 == 3 ||input.Attribut2 == 5 || input.Attribut2 == 7 || input.Attribut2 == 8 || input.Attribut2 == 9 ||  input.Attribut2 == 12 )
                             condition = "input.typeExploration == 2  ",
                             fluidRow(
                                 column(6, textOutput("titreCentreDisp1") ),
                                 column(6, textOutput("titreCentreDisp2") )
                                 ),
                             fluidRow(
                                 column(5,offset = 1, tableOutput("centreDisp1"),theme = shinytheme("flatly")),
                                 column(5, tableOutput("centreDisp2"),theme = shinytheme("flatly")),theme = shinytheme("flatly")),
                         ),
                         fluidRow(column(10, dataTableOutput("tab"),theme = shinytheme("flatly")),theme = shinytheme("flatly"))
                        
                         
                ),
                tabPanel("Diagrammes ", 
                         
                         
                         conditionalPanel( 
                             
                             condition = "input.typeExploration == 1 && ( input.Attribut1 == 1 || input.Attribut1 == 3 ||input.Attribut1 == 5 || input.Attribut1 == 7 || input.Attribut1 == 8 || input.Attribut1 == 9 ||  input.Attribut1 == 12 )", 
                             fluidRow(
                                 column(8,theme = shinytheme("flatly"), offset = 2,
                                        # Zone d'affichage du diagramme en bâtons des effectifs
                                        plotOutput(outputId = "effectifsDiag")),
                                 fluidRow(
                                   column(8,theme = shinytheme("flatly"), offset = 2,
                                          # Zone d'affichage du diagramme en bâtons des effectifs cumulés
                                          plotOutput(outputId = "effectifsCumDiag"))
                                 )
                                 
                             )),
                         
                         conditionalPanel(
                           
                           condition = "input.typeExploration == 1 && ( input.Attribut1 == 1  ||input.Attribut1 == 5  || input.Attribut1 == 8 || input.Attribut1 == 9  )", 
                           
                          
                           fluidRow(
                             column(6,
                                    # Zone d'affichage de la boîte à moustaches
                                    plotOutput(outputId = "boiteMoustaches")),
                             column(6,
                                    # Affichage des données
                                    tableOutput(outputId = "contents"))
                           )
                           
                         ),
                         
                         conditionalPanel(
                           condition = "input.typeExploration == 1 && ( input.Attribut1 == 3  ||input.Attribut1 == 7  || input.Attribut1 == 12   )",
                           fluidRow(
                             column(8,theme = shinytheme("flatly"), offset = 2,
                                    # Zone d'affichage du diagramme en bâtons des effectifs
                                    plotOutput(outputId = "diag1")),
                             fluidRow(
                               column(8,theme = shinytheme("flatly"), offset = 2,
                                      # Zone d'affichage du diagramme en bâtons des effectifs cumulés
                                      plotOutput(outputId = "diag2"))
                             )
                             )
                         ),
                             
                         
                         conditionalPanel( 
                             
                             condition = " input.typeExploration == 1 && ( input.Attribut1 == 2 || input.Attribut1 == 4 ||input.Attribut1 == 6 || input.Attribut1 == 10 || input.Attribut1 == 11 || input.Attribut1 == 13 ) ", 
                             fluidRow(
                                 column(6, 
                                        # Zone d'affichage du diagramme en colonnes des effectifs
                                        plotOutput(outputId = "colonnes")),
                                 column(6, 
                                        # Zone d'affichage du diagramme en secteurs des effectifs 
                                        plotOutput(outputId = "secteurs"))
                             ),
                             fluidRow(
                                 column(9,offset = 4, 
                                        #Affichage du titre du tableau des effectifs
                                        textOutput("titrequalitative") )),
                             fluidRow(
                                 
                                 column(6, offset = 4,
                                        # Affichage du tableau des effectifs
                                        tableOutput(outputId = "tablequalitative"))
                             )
                         ),
                         
                         conditionalPanel(
                             
                             condition = "(input.typeExploration == 2) && (output.cas == 1)", 
                             fluidRow(
                                 column(9, offset = 1,
                                        # Zone d'affichage du nuage de points
                                        plotOutput(outputId = "nuagePoints"))
                                 
                             ),
                             
                             fluidRow(
                                 column(9, offset = 1,
                                        # Zone d'affichage de histogramme à dos
                                        plotOutput(outputId = "histbackback"))
                             ),
                             
                             fluidRow(
                                 column(9,
                                        offset = 2, textOutput("titrenuagehist") )),
                             
                             fluidRow(
                                 column(9, offset = 1,
                                        # Zone d'affichage de histogramme nuage de points
                                        plotOutput(outputId = "nuagePointshist"))
                             )
                             
                         ),
                         
                         conditionalPanel(
                             
                             condition = "input.typeExploration == 2 && output.cas == 2",
                             fluidRow(
                                 column(6,
                                        # Titre du diagramme en barre 2 var
                                        offset = 3, textOutput("titrdiag2var") )
                             ),
                             fluidRow(
                                 # Zone d'affichage du diagramme en barre 2 var 
                                 column(6, plotOutput("barplotBi")),
                                 column(6, plotOutput("barplotDodgeBi"))
                                 
                             ),
                             
                             fluidRow(
                                 column(6,
                                        # Titre du diagramme profils
                                         textOutput("titrdiagprof") ),
                                 column(6,
                                        # Titre du tableau de contingence
                                         textOutput("titrtabcont") )
                             ),
                             
                             fluidRow(
                                 
                                 column(6,
                                        # Zone d'affichage du diagramme profils
                                        plotOutput("barplotProfils")),
                                 column(6,
                                        # Zone d'affichage du tableau de fréquences
                                        tableOutput("contingency"))
                                 
                                 
                             ),
                             fluidRow(
                               column(6,
                                      # Titre du tableau indices
                                      offset = 5, textOutput("titrind") )
                             ),
                             
                             fluidRow(
                                 #Zone d'affichage du tableau d'indices
                                 column(6, offset = 5, tableOutput("force"))
                             )
                             
                         ),
                         
                         conditionalPanel(
                             
                             condition = "input.typeExploration == 2 && output.cas == 3",
                             fluidRow(
                                 column(6,
                                        # Titre du diagramme des boites parallelles
                                        offset = 5, textOutput("titrboitpar") )
                             ),
                             fluidRow(
                                 column(8, offset = 3, plotOutput("boxplotBasic")),
                                
                                 
                             ),
                             fluidRow(
                                 column(8,offset = 3, plotOutput("boxplotGgplot"))
                             )
                         )
                         
                ),
                tabPanel(" Prédiction ", 
                         fluidRow(
                           column(4, style="margin-top: 20px",
                                  selectInput(inputId= "attributs", label = "Séléctionner les attributs", choices = list("age" , "anaemia", "creatinine_phosphokinase" , "diabetes", "ejection_fraction", "high_blood_pressure", "platelets", "serum_creatinine", "serum_sodium", "sex", "smoking", "time"), multiple = TRUE)),
                           column(2, style = "margin-top: 40px" ,theme = shinytheme("flatly"),
                                  actionButton(inputId = "classification", label= "Résultat de la classification"), theme = shinytheme("flatly"))
                         ),
                         fluidRow(
                           column(4,
                                  textOutput("erreur")),
                           column(6,
                                  verbatimTextOutput("confusion"))
                         ),
                         fluidRow(
                           column(8,
                                  plotOutput("plot")))
                )
            )
        )
    )
)

# Commandes  executer
server <- function(input, output){
    
    #Vecteurs statiques construit selon dataset
    attributs_noms <- c ("age", "anaemia", "creatinine_phosphokinase", "diabetes", "ejection_fraction", "high_blood_pressure", "platelets", "serum_creatinine", "serum_sodium", "sex", "smoking", "time", "DEATH_EVENT")
    type_attribut <- c (1,0,1,0,1,0,1,1,1,0, 0, 1,0) #1 quantitative 0 qualitative
    type_attributs <- c (1,0,2,0,1,0,2,1,1,0, 0, 2,0)
    
    #Recuperation du type Exploration souhaite
    typeExp <- eventReactive(input$go,{
        numero <- as.integer(0)
        numero <- input$typeExploration
        numero
    })
    #Recuperation du numero de attribut1
    attributnum1 <-eventReactive(input$go,{
        numero <- as.integer(0)
        numero <- input$Attribut1
        numero})
    #Recuperation du numero de attribut2
    attributnum2 <-eventReactive(input$go,{
        typeExpr <- as.integer(typeExp())
        numero <- as.integer(0)
        if(typeExpr == 2)
        {
            numero <- input$Attribut2
        }
        
        numero})
    #Lecture du fichier contenant des valeurs binaire, le contenu est dans data()
    data <- eventReactive(input$go, {
        inFile <- input$file1
        if (is.null(inFile)) return(NULL)
        read.csv("heart_failure_cleaned.csv", header = TRUE)
    })
    
    data2 <- eventReactive(input$go, {
        inFile <- input$file1
        if (is.null(inFile)) return(NULL)
        read.csv("heart_failure_final.csv", header = TRUE)
    })
    
    #Table de donnees
    output$tab <- renderDataTable({data2()})
   
    #Tableau des caracteristiques univarie / bivarie attribut1
    tabCentreDisp <- eventReactive(input$go,{
        #transformer typeExp en un entier
        typeExpr <- as.integer(typeExp())
        
        # transformer en entier
        attrnum <- as.integer(attributnum1())+1
        if (type_attribut[attrnum-1] == 1)
        {
          # Noms des caracteristiques
          names.tmp <- c("Maximum", "Minimum", "Moyenne", "Mediane",
                         "1e quartile", "3e quartile", "Variance", "Ecart-type")
          # Calcul des caracteristiques
          summary.tmp <- c(max(data()[,attrnum], na.rm=TRUE), min(data()[,attrnum], na.rm=TRUE), mean(data()[,attrnum], na.rm=TRUE), median(data()[,attrnum], na.rm=TRUE),
                           quantile((data()[,attrnum]), na.rm=TRUE)[2], quantile((data()[,attrnum]), na.rm=TRUE)[4],
                           var(data()[,attrnum], na.rm=TRUE), sqrt(var(data()[,attrnum], na.rm=TRUE)))
          # Ajout des noms au vecteur de valeurs
          summary.tmp <- cbind.data.frame(names.tmp, summary.tmp)
          # Ajout des noms de colonnes
          colnames(summary.tmp) <- c("Caracteristique", "Valeur")
          
          summary.tmp
        }
        
        
        
        
    })
    
    #Affichage tableau caracteristique univarie et son titre
    output$centreDisp <- renderTable({tabCentreDisp()})
    
    output$titreCentreDisp <- renderText({
        titre <-""
        attrnum <- as.integer(attributnum1())
        if (type_attribut[attrnum] == 1)
        {
          titre1 <-  eventReactive(input$go,{paste("Table des caracteristiques de la variable",attributs_noms[attrnum])}) 
          titre <- titre1()
        }
        titre
        })
    
    #Affichage tableau caracteristique bivarie et son titre attribut1
    output$centreDisp1 <- renderTable({tabCentreDisp()})
    output$titreCentreDisp1 <- renderText({
        titre <-""
        attrnum <- as.integer(attributnum1())
        if (type_attribut[attrnum] == 1)
        {
          titre1 <-  eventReactive(input$go,{paste("Table des caracteristiques de la variable",attributs_noms[attrnum])}) 
          titre <- titre1()
        }
        titre
      })
    
    #Tableau caracteristiques bivarie attribut2
    tabCentreDisp2 <- eventReactive(input$go,{
        #transformer typeExp en un entier
        typeExpr <- as.integer(typeExp())
        if(typeExpr == 2)
        {
            #transformer en entier
            attrnum <- as.integer(attributnum2())+1
            if (type_attribut[attrnum-1] == 1)
            {
              # Noms des caracteristiques
              names.tmp <- c("Maximum", "Minimum", "Moyenne", "Mediane",
                             "1e quartile", "3e quartile", "Variance", "Ecart-type")
              # Calcul des caracteristiques
              summary.tmp <- c(max(data()[,attrnum], na.rm=TRUE), min(data()[,attrnum], na.rm=TRUE), mean(data()[,attrnum], na.rm=TRUE), median(data()[,attrnum], na.rm=TRUE),
                               quantile((data()[,attrnum]), na.rm=TRUE)[2], quantile((data()[,attrnum]), na.rm=TRUE)[4],
                               var(data()[,attrnum], na.rm=TRUE), sqrt(var(data()[,attrnum], na.rm=TRUE)))
              # Ajout des nomes au vecteur de valeurs
              summary.tmp <- cbind.data.frame(names.tmp, summary.tmp)
              # Ajout des noms de colonnes
              colnames(summary.tmp) <- c("Caracteristique", "Valeur")
              
              summary.tmp
            }
           
        }
        
    })
    
    #Affichage tableau caracteristiques bivarie et son titre attribut2
    output$centreDisp2 <- renderTable({tabCentreDisp2()}) 
    output$titreCentreDisp2 <- renderText({
        titre <-""
        attrnum <- as.integer(attributnum2())
        if (type_attribut[attrnum] == 1)
        {
          titre1 <-  eventReactive(input$go,{paste("Table des caracteristiques de la variable",attributs_noms[attrnum])}) 
          titre <- titre1()
        }
       titre
      })
    
    
    ###### VOLET DIAGRAMME######
    
    ###===================== UNIVARIE================###   
    

    
    
    #========= Variable quantitative  ============#
    
    # Colonnes du tableau statistique
    tabStats <- eventReactive(input$go,{
        #transformer typeExp en un entier
        #typeExp<- reactive({input$typeExploration})
        typeExpr <- as.integer(typeExp())
        
        if(typeExpr == 1)
        {
            #recuprer l'attribut selectionne et le transformer en entier
            #attributnum <- reactive({input$Attribut1})
            attrnum <- as.integer(attributnum1())+1
            
            if (type_attribut[attrnum-1] == 1)
                {
                # Calculer les effectifs et les effectifs cumulés
                table.tmp <- as.data.frame(table(data()[attrnum]))
                table.tmp <- cbind(table.tmp, cumsum(table.tmp[[2]]))
                # Calculer les fréquences et les fréquences cumulés
                table.tmp <- cbind(table.tmp, 
                                   table.tmp[[2]]/nrow(data())*100,
                                   table.tmp[[3]]/nrow(data())*100)
                # Ajouter des noms de colonnes
                colnames(table.tmp) <- c(attributs_noms[attrnum-1], "Effectifs", "Effectifs Cum.",
                                         "Fréquences", "Fréquences Cum.")
                # - Réordonner les colonnes du tableau statistique
                # --> Ages | Effectifs | Fréquences | Effectifs Cum| Fréquences Cum.  .
                table.tmp <- table.tmp[,c(1, 2, 4, 3, 5)]
                # Renvoyer le tableau statistique
                table.tmp
            }
            
            else 
            {
              if(type_attributs[attrnum-1] == 2)
              {}
            }
            
        }
        
    })
    
    # Commande pour le chargement de données dans 'output'
    output$contents <- renderTable({ tabStats() })
    
    
    # Commande pour l'affichage du plot des effectifs  
    output$effectifsDiag <- renderPlot({  
        #transformer typeExp en un entier
        typeExpr <- as.integer(typeExp())
        
        if(typeExpr == 1)
        {   
            # transformer en entier
            attrnum <- as.integer(attributnum1())+1
            if (type_attributs[attrnum-1] == 1)
            {
               plotEff <- plot(table(data()[attrnum]), col ="green4", xlab = attributs_noms[attrnum-1], ylab ="Effectifs", 
                            main ="Distribution des effectifs ")
            }
            
            else 
            {
              if(type_attributs[attrnum-1] == 2)
              {
                plotEff <- hist(data()[,attrnum],
                     freq = TRUE, cex.axis = 1.5, cex.main = 1.5,
                     main = "Histogramme en colonnes utilisant Scott", col = "green4",ylim = c(0,200),
                     xlab = attributs_noms[attrnum-1], ylab = "Effectifs", las = 1,
                     breaks = "Scott", right = FALSE, cex.lab = 1.5)
              }
            }
           
        }
        
    }) 
    
    
    
    
    # Commande pour l'affichage du plot des fréquences cumulées
    output$effectifsCumDiag <- renderPlot({
        #transformer typeExp en un entier
        typeExpr <- as.integer(typeExp())
        if(typeExpr == 1)
        {
            # transformer en entier
            attrnum <- as.integer(attributnum1())+1
            if (type_attributs[attrnum-1] == 1)
            {
                plot(ecdf(as.numeric(as.character(tabStats()[,5]))),
                     col ="green4", xlab = attributs_noms[attrnum-1]  , ylab ="Fréquences cumulées", #
                     main ="Fréquences cumulés ")
            }
            else 
            {
              if(type_attributs[attrnum-1] == 2)
              {
                # Récupération des infos à partir de l'histogramme
                tmp.hist <- hist( data()[,attrnum], plot = FALSE,
                                  breaks = "Scott",
                                  right = FALSE)
                # Courbe cumulative (effectifs)
                plot(x = tmp.hist$breaks[-1], y = cumsum(tmp.hist$counts),
                     xlab = paste(attributs_noms[attrnum-1]," (borne sup. de chaque classe)"),
                     ylab = "Effectifs cumulés", cex.axis = 1.5, cex.lab = 1.5,
                     main = paste("Courbe cumulative de",attributs_noms[attrnum-1]),
                     type = "o", col = "green4", lwd = 2, cex.main = 1.5)
              }
              
            }
           
        }
        
        
    })
    
    
    # Commande pour l'affichage de la boîte à moustaches
    output$boiteMoustaches <- renderPlot({
        
        #transformer typeExp en un entier
        #typeExp<- reactive({input$typeExploration})
        typeExpr <- as.integer(typeExp())
        if(typeExpr == 1)
        {
            #recuprer l'attribut selectionne et le transformer en entier
            #attributnum <- reactive({input$Attribut1})
            attrnum <- as.integer(attributnum1())+1
            if (type_attributs[attrnum-1] == 1)
            {
                # Boîte à moustaches
                boxplot(data()[attrnum], col = "green 4",
                        main = "Boîte à moustaches ",
                        ylab = attributs_noms[attrnum-1], las = 1)
                # Affichage complémentaires en Y des différents modalites
                rug(data()[,1], side = 2)
            }
            else 
            {
              if(type_attributs[attrnum-1] == 2)
              {}
            }
           
        }
        
    })
  #Histogramme des frequences
output$diag1 <- renderPlot({
  #transformer typeExp en un entier
  typeExpr <- as.integer(typeExp())
  if(typeExpr == 1)
  {
    # transformer en entier
    attrnum <- as.integer(attributnum1())+1
   
      if(type_attributs[attrnum-1] == 2)
      {
        diag <- hist(tabStats()[,5], cex.axis = 1.5, cex.main = 1.5,
             main = "Histogramme en colonnes utilisant Scott", col = "green4",ylim = c(0,200),
             xlab = attributs_noms[attrnum-1], ylab = "Densité de fréquences", las = 1,
             breaks = "Scott", right = FALSE, cex.lab = 1.5)
        
      }
     
    
   diag 
  }
  
})

output$diag2 <- renderPlot({
  #transformer typeExp en un entier
  typeExpr <- as.integer(typeExp())
  if(typeExpr == 1)
  {
    # transformer en entier
    attrnum <- as.integer(attributnum1())+1
    
    if(type_attributs[attrnum-1] == 2 )
    {
      # Récupération des infos à partir de l'histogramme
      tmp.hist <- hist( tabStats()[,2], plot = FALSE,
                        breaks = "Scott",
                        right = FALSE)
      # Courbe cumulative (frequence)
      plot(x = tmp.hist$breaks[-1], y = cumsum(tmp.hist$density), 
           xlab = paste(attributs_noms[attrnum-1]," (borne sup. de chaque classe)"),
           ylab = "Effectifs cumulés", cex.axis = 1.5, cex.lab = 1.5,
           main = paste("Courbe cumulative de",attributs_noms[attrnum-1]),
           type = "o", col = "green4", lwd = 2, cex.main = 1.5)
      
      
    }
    
    
     
  }
  
})
    #========= Variable qualitative  ============#
    
    # Calcul des effectifs
    effectifs <- eventReactive(input$go,{
        typeExpr <- as.integer(typeExp())
        if(typeExpr == 1)
        {
            attrnum <- as.integer(attributnum1())+1
            if (type_attribut[attrnum-1] == 0)
            {
                table1.tmp <- as.data.frame(table(data2()[attrnum]))
                colnames(table1.tmp) <- c(attributs_noms[attrnum-1], "Effectifs")
                table1.tmp
            }
        }
        
        
    })
    
    # Table des effectifs et son titre
    output$tablequalitative <- renderTable({effectifs()})
    output$titrequalitative <- renderText({
        titre<-""
        attrnum <- as.integer(attributnum1())
        if (type_attribut[attrnum] == 0)
        {
            titre1 <-  eventReactive(input$go,{paste("Table des effectifs de la variable",attributs_noms[attrnum])})
            titre <- titre1()
        }
         
        titre
    })
    
    # Diagramme en colonnes
    output$colonnes <- renderPlot({
        #transformer typeExp en un entier
        typeExpr <- as.integer(typeExp())
        if(typeExpr == 1)
        {   attrnum <- as.integer(attributnum1())
            if (type_attribut[attrnum] == 0)
            {
                barplot(effectifs()[,2], main = "Diagramme en colonnes", ylim = c(0,200),
                        ylab="Effectifs", las = 2,
                        names.arg = effectifs()[,1] ) #substr(names(effectifs()), 1, 4)
            }
           
        }
    })
    
    # Diagramme en secteurs
    output$secteurs <- renderPlot({
        
        typeExpr <- as.integer(typeExp())
        if(typeExpr == 1)
        {
            attrnum <- as.integer(attributnum1())
            if (type_attribut[attrnum] == 0)
            {
                pie(effectifs()[,2], labels = effectifs()[,1], 
                    main = "Diagramme en secteurs", col=c())
            }
           
        }
        
    })
    
    ###===================== BIVARIE================###
    
    #determiner le cas dans lequel on est : 2 quantitatives , 2 qualitatives, une quali une quanti
    output$cas <- eventReactive(input$go,{
        #transformer typeExp en un entier
        #typeExp<- reactive({input$typeExploration})
        typeExpr <- as.integer (typeExp())
        cas <- as.integer (0)
        
        if (typeExpr == 2) {
            #attributnum1 <- reactive({input$Attribut1})
            attrnum1 <- as.integer(attributnum1())
           # attributnum2 <- reactive({input$Attribut2})
            attrnum2 <- as.integer(attributnum2()) #renderText({ paste("You chose",  attributs_noms[attrnum-1]) })
            
            if (type_attribut[attrnum1] == 1 && type_attribut[attrnum2] == 1 )
            {
                cas <- as.integer(1)
            }
            else
            {
                if (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 0)
                {
                    cas <- as.integer(2)
                }
                else
                { if ( (type_attribut[attrnum1] == 1 && type_attribut[attrnum2] == 0) || (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 1) )
                {
                    cas <- as.integer(3)
                }
                    
                }
            }
            cas
        }
        
    })
    outputOptions(output, 'cas', suspendWhenHidden = FALSE)
    
    
    
    #============ 2  variables quantitative  ============#
    
    # Nuage de points
    output$nuagePoints <- renderPlot({
       
        typeExpr <- as.integer(typeExp())
        if (typeExpr == 2) {
            
            attrnum1 <- as.integer(attributnum1())+1
            attrnum2 <- as.integer(attributnum2())+1
            if (type_attribut[attrnum1-1] == 1 && type_attribut[attrnum2-1] == 1 )
            {
                options(scipen=999)
                plot(x = data()[, attrnum1], y = data()[, attrnum2], col = "blue",
                     las = 2, cex.axis = 0.7,
                     main = paste("Nuage de points de ",attributs_noms[attrnum2-1], "en fonction de", attributs_noms[attrnum1-1]),
                     xlab = attributs_noms[attrnum1-1], ylab = attributs_noms[attrnum2-1], cex.lab = 1.2
                )
                options(scipen=0)
            }
            
        }
        
        
    })
    
    # Histogrammes dos à dos
    # ----
    output$histbackback <- renderPlot({
        
        typeExpr <- as.integer(typeExp())
        if (typeExpr == 2) {
            
            attrnum1 <- as.integer(attributnum1())+1
            attrnum2 <- as.integer(attributnum2())+1
            if (type_attribut[attrnum1-1] == 1 && type_attribut[attrnum2-1] == 1 )
            {
                options(digits=1)
                histbackback(x = data()[, attrnum1], y = data()[, attrnum2],
                             xlab = c(attributs_noms[attrnum1-1], attributs_noms[attrnum2-1]), main = paste("Histogrammes dos à dos de", attributs_noms[attrnum1-1], "et", attributs_noms[attrnum2-1]),
                             las = 2)
            }
            
        }
        
        
    })
    
    #Nuage de points et histogrammes
    output$nuagePointshist <- renderPlot({
      
        typeExpr <- as.integer(typeExp())
        if (typeExpr == 2) {
            
            attrnum1 <- as.integer(attributnum1())+1
            attrnum2 <- as.integer(attributnum2())+1
            if (type_attribut[attrnum1-1] == 1 && type_attribut[attrnum2-1] == 1 )
            {
                options(digits=1)
                x.var = data()[, attrnum1];
                y.var = data()[, attrnum2];
                scatter.with.hist( x = x.var, y =  y.var)
            }
            
        }
        
    }) 
    
    output$titrenuagehist <- renderText({
        titre<-""
        attrnum1 <- as.integer(attributnum1())
        attrnum2 <- as.integer(attributnum2())
        if (type_attribut[attrnum1] == 1 && type_attribut[attrnum2] == 1)
        {
            titre1 <-  eventReactive(input$go,{paste("Nuage de points et histogrammes de",attributs_noms[attrnum1], "et",attributs_noms[attrnum2]) })
            titre <- titre1()
        }
        
        titre
    })
    
    
           #============ 2  variables qualitative   ============#

# Diagramme en barres entre les variables colle verticalement
    output$barplotBi <- renderPlot({
        #typeExp<- reactive({input$typeExploration})
        typeExpr <- as.integer(typeExp())
        if (typeExpr == 2) {
             #attributnum1 <- reactive({input$Attribut1})
            attrnum1 <- as.integer(attributnum1())
            #attributnum2 <- reactive({input$Attribut2})
            attrnum2 <- as.integer(attributnum2())
            if (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 0)
            {
                var1 <- sym(attributs_noms[attrnum1])
                var2 <- sym(attributs_noms[attrnum2])
                ggplot(data2(), aes(x = !!var1, fill = !!var2  ), main = " Plot1") + geom_bar()
            }
           
        }
        
    })
    
    # Diagramme en barres entre les variables entre les variables colle horizontallement  
    output$barplotDodgeBi <- renderPlot({
        #typeExp<- reactive({input$typeExploration})
        typeExpr <- as.integer(typeExp())
        if (typeExpr == 2) {
            #attributnum1 <- reactive({input$Attribut1})
            attrnum1 <- as.integer(attributnum1())
            #attributnum2 <- reactive({input$Attribut2})
            attrnum2 <- as.integer(attributnum2())
            if (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 0)
            {
                var1 <- sym(attributs_noms[attrnum1])
                var2 <- sym(attributs_noms[attrnum2]) 
                ggplot(data2(), aes(x = !!var1, fill = !!var2), main = "Plot 3" ) + geom_bar(position = "dodge")
            }
            
        }
        
    })
    #Titre des diagrammes en barres des variables
    output$titrdiag2var <- renderText({
        titre<-""
        attrnum1 <- as.integer(attributnum1())
        attrnum2 <- as.integer(attributnum2())
        if (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 0)
        {
            titre1 <-  eventReactive(input$go,{paste("Diagramme en barres des variables") })
            titre <- titre1()
        }
        
        titre
    })
 
#Diagramme de profils entre les variables 
    output$barplotProfils <- renderPlot({
        #typeExp<- reactive({input$typeExploration})
        typeExpr <- as.integer(typeExp())
        if (typeExpr == 2) {
            #attributnum1 <- reactive({input$Attribut1})
            attrnum1 <- as.integer(attributnum1())
            #attributnum2 <- reactive({input$Attribut2})
            attrnum2 <- as.integer(attributnum2())
            if (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 0)
            {
                var1 <- sym(attributs_noms[attrnum1])
                var2 <- sym(attributs_noms[attrnum2])
                ggplot(data2(), aes(x = !!var1 , fill = !!var2), main = "Plot 2") + geom_bar(position = "fill")
            }
            
            
        }
    })
    output$titrdiagprof <- renderText({
        titre<-""
        attrnum1 <- as.integer(attributnum1())
        attrnum2 <- as.integer(attributnum2())
        if (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 0)
        {
            titre1 <-  eventReactive(input$go,{paste("Diagramme des profiles") })
            titre <- titre1()
        }
        
        titre
    })  
# Table de contingence entre var x et var y
    output$contingency <- renderTable({
        
        typeExpr <- as.integer(typeExp())
        if (typeExpr == 2) {
           
            attrnum1 <- as.integer(attributnum1())+1
            attrnum2 <- as.integer(attributnum2())+1
            if (type_attribut[attrnum1-1] == 0 && type_attribut[attrnum2-1] == 0)
            {
                tab = with(data2(), table(data2()[, attrnum1], data2()[, attrnum2]))
                
            }
            
        }
        
    })
    output$titrtabcont <- renderText({
        titre<-""
        attrnum1 <- as.integer(attributnum1())
        attrnum2 <- as.integer(attributnum2())
        if (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 0)
        {
            titre1 <-  eventReactive(input$go,{paste("Table de contingence") })
            titre <- titre1()
        }
        
        titre
    })
  
    output$force <- renderTable({
      force.df <- as.data.frame(matrix(NA, nrow = 3, ncol = 1))
      rownames(force.df) = c("X2", "Phi2", "Cramer")
      
      # La table de contingence des profils observés
      typeExpr <- as.integer(typeExp())
      if (typeExpr == 2) {
        
        attrnum1 <- as.integer(attributnum1())+1
        attrnum2 <- as.integer(attributnum2())+1
        if (type_attribut[attrnum1-1] == 0 && type_attribut[attrnum2-1] == 0)
        {
          tab = with(data2(), table(data2()[, attrnum1], data2()[, attrnum2]))
          
        }
        # La table de contigence s'il y a indépendence
        tab.indep = tab
        n = sum(tab)
        tab.rowSum = apply(tab, 2, sum)
        tab.colSum = apply(tab, 1, sum)
        
        for(i in c(1:length(tab.colSum))){
          for(j in c(1:length(tab.rowSum))){
            tab.indep[i,j] = tab.colSum[i]*tab.rowSum[j]/n
          }
        }
        
        # Calcul du X²
        force.df[1,1] = sum((tab-tab.indep)^2/tab.indep)
        # Calcul du Phi²
        force.df[2,1] = force.df[1,1]/n
        # Calcul du Cramer
        force.df[3,1] = sqrt(force.df[2,1]/(min(nrow(tab), ncol(tab))-1))
        
        force.df
      }
      
      
    }, rownames=TRUE, colnames= FALSE)
    
    output$titrind <- renderText({
      titre<-""
      attrnum1 <- as.integer(attributnum1())
      attrnum2 <- as.integer(attributnum2())
      if (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 0)
      {
        titre1 <-  eventReactive(input$go,{paste("Table d'indices") })
        titre <- titre1()
      }
      
      titre
    })
    #============  1  qualitative 1  quantitative  ============#
    
    # Boîtes parallèles
    output$boxplotBasic <- renderPlot({
        
        typeExpr <- as.integer(typeExp())
        if (typeExpr == 2) {
            
            attrnum1 <- as.integer(attributnum1())
            attrnum2 <- as.integer(attributnum2())
            if ( (type_attribut[attrnum1] == 1 && type_attribut[attrnum2] == 0) || (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 1) )
            {
                var1 <- sym(attributs_noms[attrnum1])
                var2 <- sym(attributs_noms[attrnum2])
                # Boxplot basique
                ggplot(data = data2(), aes(x = !!var1, y = !!var2, fill = !!var1)) +  geom_boxplot( )
            }
            
        }
        
    })
    
    output$boxplotGgplot <- renderPlot({
        
        #typeExp<- reactive({input$typeExploration})
        typeExpr <- as.integer(typeExp())
        if (typeExpr == 2) {
            
            attrnum1 <- as.integer(attributnum1())+1
            attrnum2 <- as.integer(attributnum2())+1
            if ( (type_attribut[attrnum1-1] == 1 && type_attribut[attrnum2-1] == 0) || (type_attribut[attrnum1-1] == 0 && type_attribut[attrnum2-1] == 1) )
            {
                qplot(x = data2()[, attrnum1] , y = data2()[, attrnum2], 
                      xlab = "Modalités", ylab = "Mesures",
                      geom=c("boxplot", "jitter"), fill=data2()[, attrnum1]) +
                    theme(legend.title=element_blank())
            }
           
        }
        
    })
    
    output$titrboitpar <- renderText({
        titre<-""
        attrnum1 <- as.integer(attributnum1())
        attrnum2 <- as.integer(attributnum2())
        if ( (type_attribut[attrnum1] == 1 && type_attribut[attrnum2] == 0) || (type_attribut[attrnum1] == 0 && type_attribut[attrnum2] == 1) )
        {
            titre1 <-  eventReactive(input$go,{paste("Boîtes parallèles") })
            titre <- titre1()
        }
        
        titre
    })  
    
    #============ Classification  ============#
    func_tree<-eventReactive(input$classification, {
      
      attributs = strsplit(input$attributs, split = ",") #liste des attributs
      att= ""
      for (i in attributs[[1]]){
        att<- c(att, i)
      }
      att<-c(att, "DEATH_EVENT")
      att=att[-1]
      
      df={data()}
      df = df[att]
      
      df$DEATH_EVENT<-factor(df$DEATH_EVENT)
      
      n=dim(df)[1]
      index=sample(n, 0.8*n)
      train= df[index, ]
      test=df[-index,]
      
      tree<-rpart(DEATH_EVENT~.,data=train)
      rpart.plot(tree)
      
      return (tree)
      
    })
    
    output$plot<- renderPlot({func_tree()})
    
    func_confusion<-eventReactive(input$classification, {
      
      attributs = strsplit(input$attributs, split = ",") #liste des attributs
      att= ""
      for (i in attributs[[1]]){
        att<- c(att, i)
      }
      att<-c(att, "DEATH_EVENT")
      att=att[-1]
      
      df={data()}
      df = df[att]
      
      df$DEATH_EVENT<-factor(df$DEATH_EVENT)
      
      n=dim(df)[1]
      index=sample(n, 0.8*n)
      train= df[index, ]
      test=df[-index,]
      
      tree<- {func_tree()}
      
      pred=predict(tree,test,type="class")
      test.mod<- cbind(test,pred)
      
      confusion=table(test.mod$DEATH_EVENT, test.mod$pred)
      
      return (confusion)
      
      
    })
    output$confusion<- renderPrint({func_confusion()})
    
    func_erreur<-eventReactive(input$classification, {
      
      
      confusion={func_confusion()}
      
      err <- 1-sum(diag(confusion))/sum(confusion)
      
      return (err)
      
    })
    
    output$erreur<- renderText({paste("L'erreur de classification est (Misclassification Rate) :", func_erreur())})
    
    
}





# Association interface & commandes
shinyApp(ui = ui, server = server)

