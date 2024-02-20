function [tmjd2000] = jd2mjd2000(tjd)

date     = jd2date(tjd);
tmjd2000 = date2mjd2000(date);

end