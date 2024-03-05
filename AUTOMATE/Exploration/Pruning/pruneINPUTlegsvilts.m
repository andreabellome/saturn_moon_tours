function INPUT = pruneINPUTlegsvilts(INPUT)

% DESCRIPTION
% This function is a wrapper to prune the VILTs database according to some
% criteria, namely are pruned: 1:1 transfers that are inbound-inbound;
% those transfers exceeding a max. DV; and repeated resonances, e.g., those
% with DV=0.
% 
% INPUT
% - INPUT : structure with the following fields required:
%           - LEGSvilts : matrix with VILTs. Each row is a transfer that
%           has the same structure of 'next_nodes' (see generateVILTSall.m)
%           - tolDV_leg : tolerance on the DV on a VILT [km/s]
%
% OUTPUT
% - INPUT : same structure as before with the field LEGSvilts updated
%           according to the pruning 
%
% -------------------------------------------------------------------------

% --> 1:1 resonance inbound-inbound pruned
INPUT.LEGSvilts( INPUT.LEGSvilts(:,4) == 1 & INPUT.LEGSvilts(:,5) == 1 & ...
                 INPUT.LEGSvilts(:,2) == 11 ,: ) = [];

% --> prune w.r.t. tolerance on DV
INPUT.LEGSvilts( INPUT.LEGSvilts(:,end-1) > INPUT.tolDV_leg ,: ) = [];

% --> remove repeated resonances
LEGSc           = INPUT.LEGSvilts;
LEGSc(:,3)      = [];
[~,IA]          = uniquetol(LEGSc, 1e-10, "ByRows", true);
INPUT.LEGSvilts = INPUT.LEGSvilts(IA,:);
clear LEGSc IA;

end