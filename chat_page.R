chat_tab <- bs4TabItem(
  tabName = "chat",
  h3(strong("Economic and Financial Advisor"),style="text-align:center;color:#007bff;"),
  chat_ui("gemini_chat",placeholder = "Type your message here...")
)