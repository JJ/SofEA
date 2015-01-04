initialpop.compare.time <-
  data.frame(InitialPop=c(rep('256', length(time.i256.p128.er64$V1)),
               rep('128', length(time.ip128.er64$V1))),
               Time=c(time.i256.p128.er64$V1,time.ip128.er64$V1))
initialpop.compare.evals <-
  data.frame(InitialPop=c(rep('256', length(evals.i256.p128.er64$V1)),
               rep('128', length(evals.ip128.er64$V1))),
               Evals=c(evals.i256.p128.er64$V1,evals.ip128.er64$V1))
