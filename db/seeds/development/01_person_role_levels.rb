person_role_levels = ['Keine',
                       'S1',
                       'S2',
                       'S3',
                       'S4',
                       'S5',
                       'S6']

person_role_levels.each {|n| PersonRoleLevel.seed(level: n) }
