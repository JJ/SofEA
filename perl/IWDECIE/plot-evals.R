evals.i64.p128.r64.R1 <- read.table('evals-R-i64-p128-r64-r1.dat')
evals.i64.p128.r64.R2 <- read.table('evals-R-i64-p128-r64-r2.dat')
evals.i64.p128.r32.R3 <- read.table('evals-R-i64-p128-r32-R3.dat')
evals.i64.p128.r32.R4 <- read.table('evals-R-i64-p128-r32-R4.dat')
evals.ip128.r32.R3 <- read.table('evals-R-ip128-r32-R3.dat')
evals.base <- read.table('../GECCO/evals-ip128-e16-r64.dat')
boxplot( evals.base$V1,
        evals.i64.p128.r64.R1$V1, evals.i64.p128.r64.R2$V1,
         evals.i64.p128.r32.R3$V1, evals.i64.p128.r32.R3$V1,
        evals.ip128.r32.R3$V1  )
