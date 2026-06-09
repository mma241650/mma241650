# البنية المعمارية 🏗️

## نظرة عامة على التصميم

```
┌─────────────────────────────────────┐
│   SketchUp Main Application         │
└────────────────┬────────────────────┘
                 │
        ┌────────▼──────────┐
        │   loader.rb       │ (نقطة الدخول)
        └────────┬──────────┘
                 │
    ┌────────────┼────────────┐
    │            │            │
┌───▼───┐  ┌────▼─────┐  ┌──▼────┐
│  UI   │  │ Business │  │ Utils  │
│Modules│  │ Logic    │  │Module  │
└───────┘  └──────────┘  └────────┘
```

## الملفات الرئيسية

### 1. **loader.rb** - نقطة التحميل
```ruby
# يتم تحميله تلقائياً عند بدء SketchUp
# يسجل البلاجن ويحمل جميع المكتبات المطلوبة

module KitchenCabinets
  # التحميل والتهيئة
end
```

### 2. **kitchen_cabinets.rb** - الملف الرئيسي
```ruby
# يحتوي على الفئات الأساسية:
# - Cabinet (كلاس الكابينة الأساسي)
# - CabinetBuilder (بناء الكابينات)
# - CabinetManager (إدارة الكابينات)
```

## تنظيم الملفات

```
src/
├── kitchen_cabinets.rb      ← الكود الرئيسي
│   └── classes:
│       - Cabinet
│       - CabinetBuilder
│       - CabinetManager
│
├── cabinet_builder.rb       ← بناء الكابينات
│   └── methods:
│       - create()
│       - set_dimensions()
│       - build()
│
├── cabinet_types.rb         ← الأنواع المختلفة
│   └── types:
│       - BaseCabinet
│       - WallCabinet
│       - CornerCabinet
│       - IslandCabinet
│       - SinkCabinet
│
├── components.rb            ← المكونات
│   └── classes:
│       - Door
│       - Drawer
│       - Hinge
│       - Handle
│       - Shelf
│
├── materials.rb             ← المواد
│   └── classes:
│       - Material
│       - MaterialLibrary
│       - TextureManager
│
├── exporter.rb              ← التصدير
│   └── methods:
│       - export_to_obj()
│       - export_to_dxf()
│       - export_to_pdf()
│
├── advanced_designs.rb      ← التصاميم المتقدمة
│   └── features:
│       - AdvancedLayout
│       - CustomGeometry
│       - ParametricDesign
│
├── custom_materials.rb      ← المواد المخصصة
│   └── classes:
│       - CustomMaterial
│       - TextureImporter
│
├── advanced_reporting.rb    ← التقارير
│   └── classes:
│       - Report
│       - BOMGenerator
│       - EstimateGenerator
│
├── utils/
│   ├── config.rb             ← الإعدادات
│   │   └── CONFIG = { ... }
│   │
│   └── geometry.rb           ← الحسابات الهندسية
│       └── methods:
│           - calculate_volume()
│           - calculate_surface_area()
│           - create_rectangle()
│
└── ui/
    ├── cabinet_dialog.rb    ← نافذة الإنشاء
    │   └── classes:
    │       - CabinetDialog
    │       - DimensionInput
    │       - MaterialSelector
    │
    └── design_library.rb    ← مكتبة التصاميم
        └── classes:
            - DesignLibrary
            - DesignPreview
```

## تدفق العمل

### إنشاء كابينة جديدة:

```
1. المستخدم يختار القائمة: Plugins > Kitchen Cabinets > New Cabinet
   │
2. يتم فتح نافذة الحوار (cabinet_dialog.rb)
   │
3. المستخدم يدخل البيانات (النوع، الأبعاد، المادة)
   │
4. يتم معالجة البيانات بـ CabinetBuilder
   │
5. يتم إنشاء الكائن من النوع المناسب (BaseCabinet, WallCabinet, إلخ)
   │
6. يتم إضافة المكونات (أبواب، أدراج، مفصلات)
   │
7. يتم تطبيق المواد والألوان
   │
8. يتم بناء النموذج في SketchUp
```

## الفئات الأساسية

### Cabinet Class
```ruby
class Cabinet
  attr_accessor :width, :height, :depth
  attr_accessor :material, :color
  
  def initialize
    @width = 600
    @height = 850
    @depth = 600
    @components = []
  end
  
  def add_component(component)
    @components << component
  end
  
  def build
    # بناء النموذج في SketchUp
  end
  
  def get_volume
    # حساب الحجم
  end
end
```

### CabinetBuilder Class
```ruby
class CabinetBuilder
  def self.create(type, &block)
    builder = new
    cabinet = create_cabinet(type)
    block.call(cabinet) if block
    cabinet
  end
  
  private
  
  def self.create_cabinet(type)
    case type
    when :base_cabinet
      BaseCabinet.new
    when :wall_cabinet
      WallCabinet.new
    when :corner_cabinet
      CornerCabinet.new
    # ... المزيد من الأنواع
    end
  end
end
```

### Component Classes

#### Door
```ruby
class Door
  attr_accessor :width, :height
  attr_accessor :hinge_type
  attr_accessor :open_angle
  
  def initialize(width, height, hinge_type = :standard)
    @width = width
    @height = height
    @hinge_type = hinge_type
    @open_angle = 0
  end
  
  def animate_open(duration = 2)
    # محاكاة الفتح السلس
  end
  
  def animate_close(duration = 2)
    # محاكاة الغلق السلس
  end
end
```

#### Drawer
```ruby
class Drawer
  attr_accessor :width, :depth
  attr_accessor :extension_type
  
  def initialize(width, depth, extension_type = :full)
    @width = width
    @depth = depth
    @extension_type = extension_type
    @pull_distance = 0
  end
  
  def animate_open(distance, duration = 2)
    # محاكاة فتح الدرج
  end
  
  def animate_close(duration = 2)
    # محاكاة غلق الدرج
  end
end
```

## معالجة المواد

```
Material System
├── MaterialLibrary (مكتبة المواد)
│   ├── Predefined Materials
│   │   ├── Oak Wood
│   │   ├── Maple Wood
│   │   ├── White Lacquer
│   │   └── Grey Lacquer
│   │
│   └── Custom Materials
│       ├── Color
│       ├── Texture
│       └── Finish
│
└── TextureManager (إدارة الملمس)
    ├── Load Texture
    ├── Apply Texture
    └── Save Texture
```

## نظام التقارير

```
Report System
├── BOM Generator (قائمة المواد)
│   ├── Materials List
│   ├── Hardware List
│   └── Quantities
│
├── Estimate Generator (التقدير)
│   ├── Material Costs
│   ├── Labor Costs
│   └── Total Price
│
└── Drawing Generator (الرسومات)
    ├── 2D Views
    ├── 3D Views
    └── Detailed Drawings
```

## نظام الإعدادات

```ruby
# src/utils/config.rb

CONFIG = {
  # الوحدات
  unit: :mm,                  # mm, cm, m, in
  
  # الدقة
  precision: 0.1,
  
  # الألوان الافتراضية
  default_color: [200, 200, 200],
  
  # السلوك
  auto_snap: true,
  animation_speed: 0.5,
  
  # المسارات
  materials_path: 'materials/',
  textures_path: 'textures/',
  designs_path: 'designs/',
  
  # الحدود
  max_width: 3000,
  max_height: 2500,
  max_depth: 1000,
  
  # المفصلات
  hinge_types: [:standard, :soft_close, :self_closing],
  
  # الأدراج
  drawer_types: [:full_extension, :standard, :partial]
}
```

## تدفق البيانات

```
User Input
    ↓
┌───────────────┐
│   Dialog UI   │
└───────┬───────┘
        ↓
┌───────────────────────────┐
│  CabinetBuilder           │
│  - Validates Input        │
│  - Creates Cabinet Object │
└───────┬───────────────────┘
        ↓
┌───────────────────────────┐
│  Specific Cabinet Type    │
│  (Base/Wall/Corner, etc)  │
└───────┬───────────────────┘
        ↓
┌───────────────────────────┐
│  Add Components           │
│  (Doors/Drawers/Shelves)  │
└───────┬───────────────────┘
        ↓
┌───────────────────────────┐
│  Apply Materials          │
│  & Textures               │
└───────┬───────────────────┘
        ↓
┌───────────────────────────┐
│  Build Geometry           │
│  in SketchUp              │
└───────┬───────────────────┘
        ↓
   Model in Scene
```

## تحسينات الأداء

1. **التخزين المؤقت (Caching)**
   - تخزين الأشكال الشائعة
   - تخزين المواد والملمس

2. **التقاسم (Sharing)**
   - إعادة استخدام المكونات
   - مشاركة الهندسة

3. **التحسين (Optimization)**
   - تقليل عدد الوجوه
   - دمج المكونات المتشابهة

---

**ملاحظة**: هذه البنية قابلة للتوسع والتطوير المستقبلي! 🚀
