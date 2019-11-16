Pod::Spec.new do |spec|
  spec.name = 'KeyboardObserving'
  spec.version = '0.2.1'
  spec.license = { type: 'MIT' }
  spec.homepage = 'https://github.com/nickffox/KeyboardObserving'
  spec.authors = { 'Nick Fox' => 'nicholas.f.fox@gmail.com' }
  spec.summary = 'A Combine-based way to observe and adjust for Keyboard notifications in SwiftUI'
  spec.source = {
    git: 'https://github.com/nickffox/KeyboardObserving.git',
    tag: "v#{spec.version}"
  }
  spec.source_files = 'Sources/KeyboardObserving/**/*.swift'
  spec.platform = :ios, '13.0'
  spec.swift_version = '5.1'
end
