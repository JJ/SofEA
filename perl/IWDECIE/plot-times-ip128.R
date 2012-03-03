times.i64.p128.r64.R1 <- read.table('times-R-i64-p128-r64-r1.dat')
times.i64.p128.r64.R2 <- read.table('times-R-i64-p128-r64-r2.dat')
times.i64.p128.r32.R3 <- read.table('times-R-i64-p128-r32-R3.dat')
times.i64.p128.r32.R4 <- read.table('times-R-i64-p128-r32-R4.dat')
evals.i64.p128.r16.R5 <- read.table('evals-R-i64-p128-r16-R5.dat')
evals.i64.p128.r16.R6 <- read.table('evals-R-i64-p128-r16-R5.dat')
times.base <- read.table('../GECCO/time-ip128-e16-r64.dat')
boxplot( times.base$V1,
        times.i64.p128.r64.R1$V1, times.i64.p128.r64.R2$V1,
        times.i64.p128.r32.R3$V1, times.i64.p128.r32.R3$V1,
        evals.i64.p128.r16.R5$V1, evals.i64.p128.r16.R6$V1     )
