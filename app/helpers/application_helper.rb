module ApplicationHelper
  include TSPDError
  include LinkableText
  include LinkableText::SmartFlash

  init_smart_flash UnAuthenticatedApplicationController,%w{success info warning danger}
end
