# -*- coding: utf-8 -*-
# src/kitchen_cabinets.rb - الملف الرئيسي والفئات الأساسية

require_relative 'utils/config.rb'
require_relative 'utils/geometry.rb'

module KitchenCabinets
  # الفئة الأساسية للكابينة
  class Cabinet
    attr_accessor :width, :height, :depth
    attr_accessor :material, :color
    attr_accessor :position
    attr_accessor :components
    attr_accessor :model_entity
    
    def initialize(type = :base_cabinet)
      @type = type
      @width = 600
      @height = 850
      @depth = 600
      @material = :oak_wood
      @color = Config::DEFAULT_COLORS[:light_grey]
      @position = Geom::Point3d.new(0, 0, 0)
      @components = []
      @model_entity = nil
    end

    # تعيين الأبعاد
    def set_dimensions(width, height, depth)
      validate_dimensions(width, height, depth)
      @width = width
      @height = height
      @depth = depth
    end

    # التحقق من صحة الأبعاد
    def validate_dimensions(width, height, depth)
      limits = Config::DIMENSION_LIMITS
      
      unless width >= limits[:min_width] && width <= limits[:max_width]
        raise "العرض يجب أن يكون بين #{limits[:min_width]} و #{limits[:max_width]}"
      end
      
      unless height >= limits[:min_height] && height <= limits[:max_height]
        raise "الارتفاع يجب أن يكون بين #{limits[:min_height]} و #{limits[:max_height]}"
      end
      
      unless depth >= limits[:min_depth] && depth <= limits[:max_depth]
        raise "العمق يجب أن يكون بين #{limits[:min_depth]} و #{limits[:max_depth]}"
      end
    end

    # تعيين المادة
    def set_material(material_name)
      if Config::MATERIALS.key?(material_name)
        @material = material_name
        material_data = Config::MATERIALS[material_name]
        @color = material_data[:color]
      else
        raise "المادة غير معروفة: #{material_name}"
      end
    end

    # إضافة مكون
    def add_component(component)
      @components << component
      component
    end

    # الحصول على الحجم
    def get_volume
      Geometry.calculate_volume(@width, @height, @depth)
    end

    # الحصول على مساحة السطح
    def get_surface_area
      Geometry.calculate_surface_area(@width, @height, @depth)
    end

    # تحديد الموضع
    def move_to(x, y = 0, z = 0)
      @position = Geom::Point3d.new(x, y, z)
    end

    # بناء النموذج في SketchUp
    def build
      model = Sketchup.active_model
      entities = model.active_entities
      
      # إنشاء الصندوق الأساسي
      Geometry.create_box(@width, @height, @depth, @position)
      
      # تطبيق المادة
      apply_material_to_faces(entities)
      
      # بناء المكونات
      @components.each do |component|
        component.build_in_cabinet(self)
      end
      
      puts "✅ تم بناء الكابينة بنجاح!"
    end

    # تطبيق المادة على الوجوه
    def apply_material_to_faces(entities)
      # الحصول على آخر المجموعة التي تمت إضافتها
      faces = entities.select { |e| e.class == Sketchup::Face }
      
      faces.each do |face|
        face.back_material = @material.to_s
        face.material = @material.to_s
      end
    end

    # حفظ التصميم
    def save_design(filename)
      design_data = {
        type: @type,
        width: @width,
        height: @height,
        depth: @depth,
        material: @material,
        components: @components.map(&:to_hash)
      }
      
      File.open(filename, 'w') do |f|
        require 'json'
        f.write(JSON.pretty_generate(design_data))
      end
    end

    # تحويل إلى Hash
    def to_hash
      {
        type: @type,
        width: @width,
        height: @height,
        depth: @depth,
        material: @material,
        color: @color,
        components: @components.map(&:to_hash)
      }
    end
  end

  # فئة بناء الكابينات
  class CabinetBuilder
    def self.create(type = :base_cabinet)
      cabinet = case type
                when :base_cabinet
                  Cabinet.new(:base_cabinet)
                when :wall_cabinet
                  Cabinet.new(:wall_cabinet)
                when :corner_cabinet
                  Cabinet.new(:corner_cabinet)
                when :island_cabinet
                  Cabinet.new(:island_cabinet)
                when :sink_cabinet
                  Cabinet.new(:sink_cabinet)
                when :oven_cabinet
                  Cabinet.new(:oven_cabinet)
                when :tall_cabinet
                  Cabinet.new(:tall_cabinet)
                else
                  Cabinet.new(:base_cabinet)
                end
      
      if block_given?
        yield cabinet
      end
      
      cabinet
    end

    def self.load_design(filename)
      require 'json'
      design_data = JSON.parse(File.read(filename))
      
      cabinet = create(design_data['type'].to_sym)
      cabinet.set_dimensions(
        design_data['width'],
        design_data['height'],
        design_data['depth']
      )
      cabinet.set_material(design_data['material'].to_sym)
      
      cabinet
    end
  end

  # فئة إدارة الكابينات
  class CabinetManager
    @@cabinets = []

    def self.create_cabinet(type)
      cabinet = CabinetBuilder.create(type)
      @@cabinets << cabinet
      cabinet
    end

    def self.get_all_cabinets
      @@cabinets
    end

    def self.delete_cabinet(cabinet)
      @@cabinets.delete(cabinet)
    end

    def self.count
      @@cabinets.length
    end

    def self.clear_all
      @@cabinets.clear
    end
  end
end
