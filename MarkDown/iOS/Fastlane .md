# Fastlane 

## why use fastlane

fastlane is the easiest way to automate beta deployments and releases for your iOS and Android apps. 

主要还是简单：

* android：add follow to you Fastfile

~~~ruby 
platform :android do 
    lane beta do
        gradle(
          task: "assemble",
          flavor: "WorldDomination",
          build_type: "Release"
        )
    end
end
~~~



* iOS :add follow to you Fastfile

~~~Ruby
default_platform(:ios)
platform :ios do
    lane :beta do
      increment_build_number
      build_app
      upload_to_testflight
    end
end
~~~


## what‘s fastlane

a ci (Continue Integrate) tool

what can i do when i fastlane?

1. build version bump.
2. build and archive
3. unit test
4. git
5. bugly
6. upload to differnt platform
7. config release note


## how to use fastlane

a ios demo


参考：
https://docs.fastlane.tools

