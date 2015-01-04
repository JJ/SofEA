time.ip128.e64.r32 <- read.table('time-ip128-e64-r32.dat')
time.ip128.e64.r16 <- read.table('time-ip128-e64-r16.dat')
time.ip128.e32.r64 <- read.table('time-ip128-e32-r64.dat')
time.ip128.e16.r64 <- read.table('time-ip128-e16-r64.dat')

time.ip128 <-
  data.frame(Configuration=c(rep('er64', length(time.ip128.er64$V1)),
               rep('e32r64', length(time.ip128.e32.r64$V1)),
               rep('e16r64', length(time.ip128.e16.r64$V1)),
               rep('e64r32', length(time.ip128.e64.r32$V1)),
               rep('e64r16', length(time.ip128.e64.r16$V1))),
               Time=c(time.ip128.er64$V1,
                 time.ip128.e32.r64$V1,
                 time.ip128.e16.r64$V1,
                 time.ip128.e64.r32$V1,
                 time.ip128.e64.r16$V1))


             
evals.ip128.e64.r32 <- read.table('evals-ip128-e64-r32.dat')
evals.ip128.e64.r16 <- read.table('evals-ip128-e64-r16.dat')
evals.ip128.e32.r64 <- read.table('evals-ip128-e32-r64.dat')
evals.ip128.e16.r64 <- read.table('evals-ip128-e16-r64.dat')

evals.ip128 <-
  data.frame(Configuration=c(rep('er64', length(evals.ip128.er64$V1)),
               rep('e32r64', length(evals.ip128.e32.r64$V1)),
               rep('e16r64', length(evals.ip128.e16.r64$V1)),
               rep('e64r32', length(evals.ip128.e64.r32$V1)),
               rep('e64r16', length(evals.ip128.e64.r16$V1))),
               Evals=c(evals.ip128.er64$V1,
                 evals.ip128.e32.r64$V1,
                 evals.ip128.e16.r64$V1,
                 evals.ip128.e64.r32$V1,
                 evals.ip128.e64.r16$V1))
