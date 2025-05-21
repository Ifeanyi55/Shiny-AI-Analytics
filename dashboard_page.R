dashboard_tab <- bs4TabItem(
  
  tabName = "dashboard",
  tags$style(HTML("
    .box {
      border: 3px solid #007bff !important;
      box-shadow: none !important;
    }
  ")),
  tags$link(
    href = "https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css",
    rel = "stylesheet"
  ),
  tags$script(
    src = "https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"
  ),
  tags$script( # initialize AOS after loading the script from CDN
    "
        // use jQuery to initialize AOS after document has loaded
        $(document).ready(function() {

        AOS.init({
          duration: 1000,
          once: false,
          offset: 100
        });
      });
      "
  ),
  fluidRow(
    column(3, tags$div(
      class = "animated-box",
      `data-aos` = "zoom-in",
      `data-aos-delay` = "200",
      style = "width:800px;font-size:20px;font-weight:bold;",
      valueBoxOutput("vbox1")
    )),
    column(3, tags$div(
      class = "animated-box",
      `data-aos` = "zoom-in",
      `data-aos-delay` = "200",
      style = "width:800px;font-size:20px;font-weight:bold;",
      valueBoxOutput("vbox2")
    )),
    column(3, tags$div(
      class = "animated-box",
      `data-aos` = "zoom-in",
      `data-aos-delay` = "200",
      style = "width:800px;font-size:20px;font-weight:bold;",
      valueBoxOutput("vbox3")
    )),
    column(3, tags$div(
      class = "animated-box",
      `data-aos` = "zoom-in",
      `data-aos-delay` = "200",
      style = "width:800px;font-size:20px;font-weight:bold;",
      valueBoxOutput("vbox4")
    ))
  ),
  fluidRow(
    column(6, tags$div(
      class = "animated-box",
      `data-aos` = "zoom-in",
      `data-aos-delay` = "200",
      box(
        class = "box",
        title = h5(strong("Bar Chart of Total GDP per Country"),
                   style = "text-align:center;"
        ),
        status = "primary",
        icon = icon("chart-bar"),
        solidHeader = TRUE,
        width = 12,
        elevation = 4,
        highchartOutput("drill_bar")
      )
    )),
    column(6, tags$div(
      class = "animated-box",
      `data-aos` = "zoom-in",
      `data-aos-delay` = "200",
      box(
        class = "box",
        title = h5(strong("Pie Chart of Total GDP per Country"),
                   style = "text-align:center;"
        ),
        status = "primary",
        icon = icon("pie-chart"),
        solidHeader = TRUE,
        width = 12,
        elevation = 4,
        highchartOutput("drill_pie")
      )
    ))
  ),
  hr(),
  h4(strong("Country Fact Zone"), style = "text-align:center;"),
  fluidRow(
    tags$div(
      `data-aos` = "fade-up",
      `data-aos-delay` = "200",
      box(
        class = "box",
        title = h5(strong("Learn 10 Facts about the selected country"),
                   style = "text-align:center;"
        ),
        status = "primary",
        icon = icon("info-circle"),
        solidHeader = TRUE,
        width = 12,
        elevation = 4,
        selectizeInput(
          inputId = "country",
          label = strong("Select A Country"),
          width = "20%",
          choices = unique(gdp_data$country),
          selected = "Algeria"
        ),
        uiOutput("ai_response")
      )
    )
  )
)