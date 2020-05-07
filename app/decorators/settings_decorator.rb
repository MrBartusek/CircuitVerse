# frozen_string_literal: true

class SettingsDecorator < SimpleDelegator

  def settings
    __getobj__
  end

  def format_setting(name)
    if name == "test_setting" then
      return 'Test Setting', 'Test new Settings System'
    else
      return name, "Missing frendly name and description"
    end
  end

  def group_name(definition)
    splited = definition[0].to_s.split('_')
    if splited.length < 2 then
      "Unknown Group"
    else
      splited[0]
    end
  end

  def setting_name(definition)
    class_name = definition[0].to_s
    class_name.slice! group_name(definition)
    class_name.slice!(0)
    class_name
  end

end
  