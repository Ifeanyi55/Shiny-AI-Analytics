library(shiny)
library(shinymanager)
library(shinychat)
library(bs4Dash)
library(gapminder)
library(highcharter)
library(markdown)

# create data of the first 60 rows in gapminder
gdp_data <- gapminder[1:60,]

# read in modules
source("dashboard_page.R")
source("chat_page.R")
source("gradio_page.R")

dash_title <- dashboardBrand(
  title = "Economic Data",
  color = "primary",
  href = "https://www.gapminder.org/data/",
  image = "bars.jpg"
)

# secure_app(

# define UI for application that displays economic data
dashboardPage(
  title = "Economic Data",
  help = NULL,
  dark = NULL,
  fullscreen = T,
  scrollToTop = T,
  header = dashboardHeader(title = dash_title),
  sidebar = dashboardSidebar(
    skin = "light",
    status = "primary",
    sidebarMenu(
      menuItem("Analytics", tabName = "dashboard", icon = icon("chart-bar")),
      menuItem("Economic Advisor", tabName = "chat", icon = icon("comment")),
      menuItem("Explore Data", tabName = "explore", icon = icon("chart-pie")),
      menuItem("AI Interface", tabName = "gradio", icon = icon("microchip"))
    )
  ),
  body = dashboardBody(
    bs4TabItems(
      dashboard_tab,
      chat_tab,
      gradio_tab
    )
  ),
  footer = dashboardFooter(
    left = h5(strong("Source: Gapminder @2025"),style = "color:#007bff;"),
    right = h5(strong("Powered by Gemini AI"),style = "color:#007bff;"))
)
# )