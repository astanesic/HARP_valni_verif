library(harp)
library(here)
fcst <- read_point_forecast(dttm = seq_dttm(2023010300,2023022800,"24h"), fcst_model=c("WWM3","WWM3s","WAM"),fcst_type = "det",file_path = c("FC"), parameter = "SWH",  lead_time = seq(0, 72, 1))
fcst <- common_cases(fcst)
obs <- read_point_obs(dttm = unique_valid_dttm(fcst),parameter = "SWH",stations = unique_stations(fcst),obs_path=c("OBS"))

fcst <- join_to_fcst(fcst,obs)

fcst<-check_obs_against_fcst(fcst,SWH)
verif <- det_verify(fcst,"SWH")


plot_point_verif(verif,"bias")
ggsave("bias_all.png")
plot_point_verif(verif,"rmse")
ggsave("rmse_all.png")
plot_point_verif(verif,"stde")
ggsave("stde_all.png")

verif <- det_verify(fcst,"SWH",groupings = c("lead_time","SID"))
plot_point_verif(verif,"stde",facet_by=vars(SID),num_facet_cols = 1)
ggsave("stde_by_SID_and_lt.png",width=8.75, height=8.75)

plot_point_verif(verif,"bias",facet_by=vars(SID),num_facet_cols = 1)
ggsave("bias_by_SID_and_lt.png",width=8.75, height=8.75)

plot_point_verif(verif,"rmse",facet_by=vars(SID),num_facet_cols = 1)
ggsave("rmse_by_SID_and_lt.png",width=8.75, height=8.75)

verif <- det_verify(fcst,"SWH",groupings = c("SID"))
plot_point_verif(verif,"stde",x_axis = SID)
ggsave("stde_by_SID.png")


plot_point_verif(verif,"bias",x_axis = SID)
ggsave("bias_by_SID.png")

plot_point_verif(verif,"rmse",x_axis = SID)
ggsave("rmse_by_SID.png")


#verif <- det_verify(fcst,"SWH",thresholds = c(0.00001,0.1,0.5,1.3,2.5,4,5),groupings=c("threshold","SID"))
verif <- det_verify(fcst,"SWH",thresholds = c(0.00001,0.5,1.3,2.5,4,5),groupings=c("threshold","SID"))
plot_point_verif(verif, extreme_dependency_index,x_axis=threshold,facet_by = vars(SID))


#graf mjerenja vs postaja
plot_station_ts(fcst,fcst_dttm="20230120",SID=5,facet_by=vars(fcst_model),obs_col= SWH )
plot_station_ts(fcst,fcst_dttm="20230120",facet_by=vars(SID),fcst_colour_by=fcst_model,obs_col= SWH )
datum=c("20230117","20230118","20230119","20230110","20230109","20230226","20230204")

for (d in datum) {
  ofile=paste(d,".png",sep="")
  plot_station_ts(fcst,fcst_dttm=d,facet_by=vars(SID),fcst_colour_by=fcst_model,obs_col= SWH,x_axis = valid_dttm)
  ggsave(ofile)
}
