department_names =  ["/dev/one",
                      "/dev/two",
                      "/dev/tre",
                      "/dev/ruby",
                      "/mid",
                      "/ux",
                      "/zh",
                      "/sys",
                      "/bs",
                      "/racoon",
                      "/bbt",
                      "Funktionsbereiche"]

department_names.each {|n| Department.seed(name: n) }
