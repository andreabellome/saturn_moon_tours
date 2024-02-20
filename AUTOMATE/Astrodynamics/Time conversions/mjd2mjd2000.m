function [mjd2000] = mjd2mjd2000(mjd)

% from MJD to MJ2000

date    = mjd2date(mjd);      % from MJD to DATE
mjd2000 = date2mjd2000(date); % from DATE to MJD2000

end