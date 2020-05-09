# frozen_string_literal: true

class SettingsDecorator < SimpleDelegator

  def settings
    __getobj__
  end

  def group_name(full_name)
    words = full_name.to_s.split('_')
    if words.length < 2 then
      "Unknown Group"
    else
      words[0].capitalize
    end
  end

  def setting_name(full_name)
    words = full_name.to_s.split('_')
    result = full_name.to_s;
    result.slice! words[0] + '_'
    result
  end

  def format_setting_name(name)
    if name == "test_setting" then
      return 'Test Setting', 'Test new Settings System'
    else
      return name, "Missing frendly name and description"
    end
  end
end
  