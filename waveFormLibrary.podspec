Pod::Spec.new do |s|
  s.name         = "waveFormLibrary"
  s.version      = "1.0"
  s.summary      = "draw waveform of mp3 file"

  s.description  = "draw waveform and display current position."

  s.homepage     = "https://github.com/duongsonthong/waveFormLibrary"
  s.license      = "MIT"

  s.author       = "duongsonthong"

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/duongsonthong/waveFormLibrary.git", :tag => "1.0" }

  s.source_files  = "waveFormLibrary"

end
