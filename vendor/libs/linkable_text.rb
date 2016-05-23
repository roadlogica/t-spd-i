module LinkableText

  # ***README***
  #
  # 1.LinkableText should be included by ViewHelper
  #
  # 2.LinkableText is design to parse text like {title:address} to <a href='address'>title</>
  #   eg. "{Click To Google,https://google.com.hk}".auto_link_text()
  #   generate sth like <a href='https://google.com.hk'>Click To Google</a>
  #
  # edited by arybin

  def self.included(base)
    init(base)
  end


  def self.init(view_helper)
    pattern=/(\{.*?,.*?\})/
    pattern_strict=/(^\{(.*?),(.*?)\}$)/

    #metaprogramming - flat scope for beauty and clean
    String.send :define_method, :is_quick_link? do
      match pattern_strict
    end

    String.send :define_method, :to_linkable_texts do
      split pattern
    end

    String.send :define_method, :quick_link_text do
      match(pattern_strict) && $2
    end

    String.send :define_method, :quick_link_addr do
      match(pattern_strict) && $3
    end

    view_helper.send :define_method, :auto_link_text do |text|
      text.is_quick_link? ? link_to(text.quick_link_text, text.quick_link_addr) : text
    end

  end


  module SmartFlash
    # ***README***
    #
    # 1.SmartFlash should be included by ViewHelper and initiated with the controller which will
    # gain the some features of SmartFlash through the method init_smart_flash(controller,flash_types)
    #
    #
    # 2.SmartFlash provides an easy way to generate LinkableText with params in link(HTTP GET). For example,
    # firstly initiate SmartFlashes in ViewHelper through:
    # init_smart_flash(ApplicationController,[:success,:danger])
    # and then in any action controller, we can "put" specific type of SmartFlash like:
    # push_success('success!')
    # push_danger('danger!')
    # the push_xxx methods is generated automatically.
    #
    #
    # 3.SmartFlash can generate LinkableText with params.
    # eg.
    # push_success('{Click To Redirect,https://google.com.hk}') do |param|
    #   param[:a]=1
    #   param[:b]=2
    # end
    # will generate sth like(in html):
    # <a href='https://google.com.hk?a=1&b=2'>Click To Redirect</a>
    #
    # 4.SmartFlash can generate LinkableText with multiple params.
    # eg.
    # push_success('Choose to {A,url_a}, or {B,url_b}, or do nothing.') do |param1,param2|
    #   param1[:debug]=true
    #   param2[:debug]=false
    # end
    # will generate sth like(in html):
    # Choose to <a href='url_a?debug=true'>A</a>, or <a href='url_b?debug=false'>B</a>, or do nothing.
    #
    # edited by arybin


    def self.included(base)
      init_macro(base)
    end

    def self.init_macro(base)
      base.singleton_class.send :define_method, :init_smart_flash do |controller, flash_types|

        base.send :define_method, :smart_flash_types do
          flash_types
        end

        base.send :define_method, :get_smart_flash do |type|
          instance_variable_get("@#{type.pluralize}")
        end

        flash_types.each do |type|
          #"set" methods
          controller.send :define_method, "push_#{type}" do |msg, &block|
            tmp=msg
            if base.include?(LinkableText) && block
              tmp=String.new
              parsed_msgs = msg.to_linkable_texts
              quick_links = parsed_msgs.select &:is_quick_link?
              params = Array.new(quick_links.size, Hash.new)
              #retrieve params from block
              block[*params]
              parsed_msgs.each do |sth|
                tmp << (sth.is_quick_link? ? "{#{sth.quick_link_text},#{sth.quick_link_addr}?#{params.shift.to_param}}" : sth)
              end
            end
            instance_variable_get("@#{type.pluralize}")<<tmp
            self
          end
        end

        controller.send :define_method, :reset_smart_flashes do
          flash_types.each do |type|
            instance_variable_set "@#{type.pluralize}", []
          end
        end
        controller.before_action :reset_smart_flashes
      end
    end

  end


end
