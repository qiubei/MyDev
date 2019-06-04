
Pod::Spec.new do |s|
  s.name             = 'NaptimeFileProtocol'
  s.version          = '0.3.0'
  s.summary          = 'Naptime 文件协议'
  s.description      = <<-DESC
Naptime 文件协议库
                       DESC

  s.homepage         = 'https://github.com/EnterTech'
  s.author           = { 'HyanCat' => 'hyancat@live.cn' }
  s.license          = 'LICENSE'
  s.source           = { :git => 'git@github.com:EnterTech/NaptimeFileProtocol.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'NaptimeFileProtocol/Classes/**/*'

end
