# -*- coding: utf-8 -*-
# SketchUp Kitchen Cabinets Plugin - Complete Version

# Main entry point - loader.rb
require 'fileutils'

module KitchenCabinets
  VERSION = '1.0.0'
  PLUGIN_NAME = 'SketchUp Kitchen Cabinets'
  PLUGIN_PATH = File.dirname(__FILE__)

  def self.load_plugin
    begin
      load_core_files
      register_menus
      register_commands
      puts "✅ #{PLUGIN_NAME} v#{VERSION} loaded successfully!"
    rescue => error
      puts "❌ Error loading plugin: #{error.message}"
      puts error.backtrace.join("\n")
    end
  end

  def self.load_core_files
    files = [
      'src/utils/config.rb',
      'src/utils/geometry.rb',
      'src/kitchen_cabinets.rb',
      'src/cabinet_types.rb',
      'src/components.rb',
      'src/materials.rb',
      'src/cabinet_builder.rb',
      'src/exporter.rb',
      'src/advanced_designs.rb',
      'src/custom_materials.rb',
      'src/advanced_reporting.rb',
      'src/ui/cabinet_dialog.rb',
      'src/ui/design_library.rb'
    ]
    
    files.each do |file|
      full_path = File.join(PLUGIN_PATH, file)
      if File.exist?(full_path)
        load full_path
      else
        puts "⚠️ Warning: File not found - #{file}"
      end
    end
  end

  def self.register_menus
    menu = UI.menu('Plugins')
    menu.add_separator
    menu.add_item('Kitchen Cabinets') { show_main_menu }
    menu.add_separator
  end

  def self.register_commands
  end

  def self.show_main_menu
    UI.messagebox('Welcome to Kitchen Cabinet Designer!')
  end
end

KitchenCabinets.load_plugin
