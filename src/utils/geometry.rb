# -*- coding: utf-8 -*-
# src/utils/geometry.rb - الحسابات الهندسية والأشكال

module KitchenCabinets
  module Geometry
    # إنشاء مستطيل ثنائي الأبعاد
    def self.create_rectangle(width, height, position = ORIGIN)
      points = [
        [position.x, position.y, position.z],
        [position.x + width, position.y, position.z],
        [position.x + width, position.y + height, position.z],
        [position.x, position.y + height, position.z]
      ]
      points
    end

    # إنشاء صندوق ثلاثي الأبعاد
    def self.create_box(width, height, depth, position = ORIGIN)
      model = Sketchup.active_model
      entities = model.active_entities
      
      # النقاط الأمامية
      front_points = create_rectangle(width, height, position)
      
      # النقاط الخلفية
      back_position = Geom::Point3d.new(
        position.x, 
        position.y + depth, 
        position.z
      )
      back_points = create_rectangle(width, height, back_position)

      # إنشاء الوجوه
      faces = []
      
      # الوجه الأمامي
      front_face = entities.add_face(front_points)
      faces << front_face
      
      # الوجه الخلفي
      back_face = entities.add_face(back_points.reverse)
      faces << back_face
      
      # الوجوه الجانبية
      # الجانب الأيسر
      left_face = entities.add_face([
        front_points[0],
        front_points[3],
        back_points[3],
        back_points[0]
      ])
      faces << left_face
      
      # الجانب الأيمن
      right_face = entities.add_face([
        front_points[1],
        back_points[1],
        back_points[2],
        front_points[2]
      ])
      faces << right_face
      
      # الأعلى
      top_face = entities.add_face([
        front_points[3],
        front_points[2],
        back_points[2],
        back_points[3]
      ])
      faces << top_face
      
      # الأسفل
      bottom_face = entities.add_face([
        front_points[0],
        back_points[0],
        back_points[1],
        front_points[1]
      ])
      faces << bottom_face
      
      faces
    end

    # حساب حجم الصندوق
    def self.calculate_volume(width, height, depth)
      width * height * depth
    end

    # حساب مساحة السطح
    def self.calculate_surface_area(width, height, depth)
      2 * (width * height + height * depth + width * depth)
    end

    # حساب المحيط
    def self.calculate_perimeter(width, depth)
      2 * (width + depth)
    end

    # تحويل المسافة إلى وحدة أخرى
    def self.convert_unit(value, from_unit, to_unit)
      conversions = {
        mm_to_cm: 0.1,
        mm_to_m: 0.001,
        mm_to_in: 0.0393701,
        cm_to_mm: 10,
        cm_to_m: 0.01,
        cm_to_in: 0.393701,
        m_to_mm: 1000,
        m_to_cm: 100,
        m_to_in: 39.3701,
        in_to_mm: 25.4,
        in_to_cm: 2.54,
        in_to_m: 0.0254
      }
      
      key = "#{from_unit}_to_#{to_unit}".to_sym
      if conversions[key]
        value * conversions[key]
      else
        value
      end
    end

    # إنشاء دائرة
    def self.create_circle(radius, position = ORIGIN, segments = 24)
      points = []
      segments.times do |i|
        angle = (i.to_f / segments) * 2 * Math::PI
        x = position.x + radius * Math.cos(angle)
        y = position.y + radius * Math.sin(angle)
        z = position.z
        points << Geom::Point3d.new(x, y, z)
      end
      points
    end

    # إنشاء أسطوانة
    def self.create_cylinder(radius, height, position = ORIGIN, segments = 24)
      model = Sketchup.active_model
      entities = model.active_entities
      
      # القاعدة السفلية
      bottom_circle = create_circle(radius, position, segments)
      
      # القاعدة العلوية
      top_position = Geom::Point3d.new(position.x, position.y, position.z + height)
      top_circle = create_circle(radius, top_position, segments)
      
      faces = []
      
      # الجانب الأسطواني
      segments.times do |i|
        next_i = (i + 1) % segments
        face = entities.add_face([
          bottom_circle[i],
          bottom_circle[next_i],
          top_circle[next_i],
          top_circle[i]
        ])
        faces << face
      end
      
      faces
    end

    # حساب المسافة بين نقطتين
    def self.distance(point1, point2)
      Math.sqrt(
        (point2.x - point1.x) ** 2 +
        (point2.y - point1.y) ** 2 +
        (point2.z - point1.z) ** 2
      )
    end

    # إنشاء مصفوفة انتقال
    def self.create_translation_matrix(dx, dy, dz)
      Geom::Transformation.translation([dx, dy, dz])
    end

    # إنشاء مصفوفة دوران
    def self.create_rotation_matrix(axis, angle, center_point = ORIGIN)
      Geom::Transformation.rotation(center_point, axis, angle)
    end

    # إنشاء مصفوفة تحجيم
    def self.create_scale_matrix(scale_factor, center_point = ORIGIN)
      Geom::Transformation.scaling(center_point, scale_factor)
    end
  end
end
