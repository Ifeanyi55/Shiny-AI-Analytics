library(shiny)
library(shinychat)
library(shinymanager)
library(bs4Dash)
library(gapminder)
library(highcharter)
library(dplyr)
library(ellmer)

# define login credentials
# credentials <- data.frame(
#   user = c("user1", "admin"), # usernames
#   password = c("pass1", "adminpass"), # passwords
#   stringsAsFactors = FALSE
# )

# set Gemini api key
Sys.setenv(GEMINI_API_KEY = "AIzaSyAau0taEMZoOPtqDS-K_ZxiN6lycfcJ_pE")

# get Gemini api key
api_key = Sys.getenv("GEMINI_API_KEY")


# Define server logic required to build plots
function(input, output, session) {
  
    # call secure_server to manage authentication
    # res_auth <- secure_server(
    #   check_credentials = check_credentials(credentials)
    # )
    # 
  
    # write logic for AI response
    output$ai_response <- renderUI(

      {
        tryCatch(
          {
            chat <- chat_gemini(system_prompt = "You are a knowledgeable and helpful assistant",
                                model = "gemini-1.5-flash",
                                api_key = api_key,
                                echo = T)

            resp <- chat$chat(paste("Give 10 facts about", input$country))

            HTML(markdown::markdownToHTML(text = resp, fragment.only = TRUE))
          },
          error = function(e) {
            HTML(markdown::markdownToHTML(text = paste("**Error getting a response from Gemini API.This could be as a result of unstable internet connection.**"), 
                                          fragment.only = TRUE))
          }
        )
      }
    )
    
    # write logic for Gemini chat
    gemini <- chat_gemini(
      system_prompt = "You are an economic and financial expert who only answers questions around country economy and finance. If a user asks a question that is not related to economics or finance, give the following polite response: 'I'm sorry, I can only give economic and financial advice'.",
      model = "gemini-1.5-flash",
      api_key = api_key,
      echo = T
    )
    
    observeEvent(input$gemini_chat_user_input, {
      # input$gemini_chat_user_input is from the chat id in the UI
      
      gemini$chat_async(input$gemini_chat_user_input)$then(function(response) {
        chat_append("gemini_chat", response)
      })$catch(function(error) {
        warning("An error occurred during chat_async: ", error$message)
      })
    })

    output$drill_bar <- renderHighchart(
      
      {
        tryCatch(
          {
            gdp_data <- gapminder[1:60,]
            
            # total gdp per capita per continent
            gdp_country <- gdp_data |> 
              group_by(country) |> 
              summarize(
                total_gdp = sum(gdpPercap)
              ) |> 
              arrange(desc(total_gdp))
            
            # create drilldown data
            drill_down_data <- gdp_data |> 
              group_nest(country) |> 
              mutate(
                id = country,
                type = "column",
                data = map(data,mutate,name = year, y = gdpPercap),
                data = map(data,list_parse)
              )
            
            # create drilldown visualization
            hc_drill <- hchart(
              gdp_country,
              type = "column",
              hcaes(x = country, y = total_gdp, drilldown = country),
              name = "GDP",
              colorByPoint = TRUE) |> 
              hc_drilldown(
                allowPointDrilldown = TRUE,
                series = list_parse(drill_down_data)
              )
            
            hc_drill  
            
          },
          error = function(e) {
            highchart() |>
              hc_title(text = "No data available to display")
          }
        )
      }
    )
    
    output$drill_pie <- renderHighchart(
      
      {
        tryCatch(
          {
            gdp_data <- gapminder[1:60,]
            
            # total gdp per continent
            gdp_continent <- gdp_data |> 
              group_by(continent) |> 
              summarize(
                total_gdp_cont = sum(gdpPercap)
              ) |> 
              arrange(desc(total_gdp_cont))
            
            # total gdp per capita per country
            gdp_country <- gdp_data |> 
              group_by(country) |> 
              summarize(
                total_gdp = sum(gdpPercap)
              ) |> 
              arrange(desc(total_gdp))
            
            # create drilldown data
            drill_down_data <- gdp_data |> 
              group_nest(country) |> 
              mutate(
                id = country,
                type = "column",
                data = map(data,mutate,name = year, y = gdpPercap),
                data = map(data,list_parse)
              )
            
            pie_drill <- hchart(
              gdp_country,
              type = "pie",
              hcaes(x = country, y = total_gdp, drilldown = country),
              name = "GDP",
              colorByPoint = TRUE) |> 
              hc_drilldown(
                allowPointDrilldown = TRUE,
                series = list_parse(drill_down_data),
                activeAxisLabelStyle = ".highcharts-drilldown-data-label{textDecoration:none}"
              )
            
            pie_drill
          },
          error = function(e) {
            highchart() |>
              hc_title(text = "No data available to display")
          }
        )
      }
    )
    
    output$vbox1 <- renderValueBox(
      
      {
        tryCatch(
          {
            # total gdp per continent
            gdp_continent <- gdp_data |> 
              group_by(continent) |> 
              summarize(
                total_gdp_cont = sum(gdpPercap)
              ) |> 
              arrange(desc(total_gdp_cont))
            
            amr_gdp <- gdp_continent |> 
              filter(continent == "Americas")
            
            valueBox(
              value = round(amr_gdp$total_gdp_cont,1),
              color = "success",
              icon = icon("dollar"),
              elevation = 4,
              width = 4,
              subtitle = " ",
              footer = "Total GDP: Americas"
            )
          },
          error = function(e) {
            valueBox(
              value = 0,
              color = "danger",
              icon = icon("exclamation-triangle"),
              elevation = 4,
              width = 4,
              subtitle = " ",
              footer = "Error fetching data"
            )
          }
        )
      }
    )
    
    output$vbox2 <- renderValueBox(
      
      {
        tryCatch(
          {
            # total gdp per continent
            gdp_continent <- gdp_data |> 
              group_by(continent) |> 
              summarize(
                total_gdp_cont = sum(gdpPercap)
              ) |> 
              arrange(desc(total_gdp_cont))
            
            afr_gdp <- gdp_continent |> 
              filter(continent == "Africa")
            
            valueBox(
              value = round(afr_gdp$total_gdp_cont,1),
              color = "info",
              icon = icon("dollar"),
              elevation = 4,
              width = 4,
              subtitle = " ",
              footer = "Total GDP: Africa"
            )
          },
          error = function(e) {
            valueBox(
              value = 0,
              color = "danger",
              icon = icon("exclamation-triangle"),
              elevation = 4,
              width = 4,
              subtitle = " ",
              footer = "Error fetching data"
            )
          }
        )
      }
    )
    
    output$vbox3 <- renderValueBox(
      
      {
        tryCatch(
          {
            # total gdp per continent
            gdp_continent <- gdp_data |> 
              group_by(continent) |> 
              summarize(
                total_gdp_cont = sum(gdpPercap)
              ) |> 
              arrange(desc(total_gdp_cont))
            
            asia_gdp <- gdp_continent |> 
              filter(continent == "Asia")
            
            valueBox(
              value = round(asia_gdp$total_gdp_cont,1),
              color = "danger",
              icon = icon("dollar"),
              elevation = 4,
              width = 4,
              subtitle = " ",
              footer = "Total GDP: Asia"
            )
          },
          error = function(e) {
            valueBox(
              value = 0,
              color = "danger",
              icon = icon("exclamation-triangle"),
              elevation = 4,
              width = 4,
              subtitle = " ",
              footer = "Error fetching data"
            )
          }
        )
      }
    )
    
    
    output$vbox4 <- renderValueBox(
      
      {
        tryCatch(
          {
            # total gdp per continent
            gdp_continent <- gdp_data |> 
              group_by(continent) |> 
              summarize(
                total_gdp_cont = sum(gdpPercap)
              ) |> 
              arrange(desc(total_gdp_cont))
            
            eur_gdp <- gdp_continent |> 
              filter(continent == "Europe")
            
            valueBox(
              value = round(eur_gdp$total_gdp_cont,1),
              color = "warning",
              icon = icon("dollar"),
              elevation = 4,
              width = 4,
              subtitle = " ",
              footer = "Total GDP: Europe"
            )
          },
          error = function(e) {
            valueBox(
              value = 0,
              color = "danger",
              icon = icon("exclamation-triangle"),
              elevation = 4,
              width = 4,
              subtitle = " ",
              footer = "Error fetching data"
            )
          }
        )
      }
    )
}
