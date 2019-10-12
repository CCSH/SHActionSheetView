

Pod::Spec.new do |s|

    s.name         = "SHActionSheetView"
    s.version      = "1.1.1"
    s.summary      = "SHActionSheetView 弹框"
    s.license      = "MIT"
    s.authors      = { "CSH" => "624089195@qq.com" }
    s.platform     = :ios, "6.0"
    s.homepage     = "https://github.com/CCSH/SHActionSheetView"
    s.source       = {:git => "https://github.com/CCSH/SHActionSheetView.git", :tag => s.version }
    s.source_files = "SHActionSheetView/*.{h,m}"
    s.requires_arc = true

end
