Pod::Spec.new do |s|

  s.name         = "Throttler"
  s.version      = "1.0.0"
  s.summary      = "A component you can use for regulating the rate of performing a process."
  s.description  = <<-DESC
                   Throttler is a component you can use for regulating the rate
                   of performing a process.  Processes can easily be defined by
                   using a closure.  Processes are dispatched asychronously to
                   the provided queue.

                   Throttler can also be customized to change its delay time and
                   dipatch queue.
                   DESC

  s.homepage     = "https://github.com/dechhay/Throttler"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Dennis Chhay" => "dennis@dennischhay.com" }

  s.ios.deployment_target = "11.0"
  s.source       = { :git => "https://github.com/dechhay/Throttler.git", :tag => "#{s.version}" }
  s.source_files = "Throttler/Code/*.swift"
  s.swift_version = '4.0'

end
