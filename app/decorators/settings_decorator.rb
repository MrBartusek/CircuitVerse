# frozen_string_literal: true

class SettingsDecorator < SimpleDelegator

  def settings
    __getobj__
  end

  def organize_definitions
    organized = Hash.new
    User.storext_definitions.each do |definition|
      group = group_name(definition[0])
      setting = setting_name(definition[0])
      if organized[group].nil? then
        organized[group] = Hash.new
      end

      organized[group][setting] = {
          full_name: definition[0],
          value: settings[definition[0]],
          default: definition[1][:opts][:default],
          frendly_name: format_setting_name(definition[0])[0],
          frendly_description: format_setting_name(definition[0])[1],
        }
    end
    organized
  end
  
  private
  def group_name(full_name)
    words = full_name.to_s.split('_')
    if words.length < 2 then
      "Unknown Group"
    else
      words[0]
    end
  end

  def setting_name(full_name)
    words = full_name.to_s.split('_')
    result = full_name.to_s;
    result.slice! words[0] + '_'
    result
  end

  def format_setting_name(name)
    if name.to_s == "platform_test_setting" then
      return 'Test Setting', 'Test new Settings System'
    else
      return name, "Missing frendly name and description"
    end
  end
end
  