#!/bin/sh

# Generated for CMSSW_20_1_0_pre4 / Run4D128.
# Derived from produceSkeletons_D121.sh (CMSSW_20_0_0_pre1 / Run4D121), adapted by:
#   - geometry: ExtendedRun4D121 -> ExtendedRun4D128
#   - era: Phase2C22I13M9 -> Phase2C26I13M9 (the Run4D128 era in 20_1,
#     see Configuration/PyReleaseValidation/python/upgradeWorkflowComponents.py)
#   - conditions: auto:phase2_realistic_T35 (unchanged)
#   - the PU fragment is generated with a placeholder pileup input instead of
#     a DAS query (no proxy needed); GSD_GUN.py fills mix.input.fileNames at
#     runtime from its pu=<file> argument, so the placeholder is blanked below.

action() {

  cmsDriver.py SingleElectronPt10_pythia8_cfi \
    --conditions auto:phase2_realistic_T35 \
    -n 10 \
    --era Phase2C26I13M9 \
    --eventcontent FEVTDEBUG \
    -s GEN,SIM,DIGI:pdigi_valid,L1TrackTrigger,L1,L1P2GT,DIGI2RAW,HLT:@relvalRun4 \
    --datatier GEN-SIM \
    --beamspot NoSmear \
    --geometry ExtendedRun4D128 \
    --procModifier fineCalo \
    --no_exec \
    --python_filename=GSDfineCalo_fragment.py

  cmsDriver.py SingleElectronPt10_pythia8_cfi \
    --conditions auto:phase2_realistic_T35 \
    -n 10 \
    --era Phase2C26I13M9 \
    --eventcontent FEVTDEBUG \
    -s GEN,SIM,DIGI:pdigi_valid,L1TrackTrigger,L1,L1P2GT,DIGI2RAW,HLT:@relvalRun4 \
    --datatier GEN-SIM-DIGI-RAW \
    --beamspot NoSmear \
    --geometry ExtendedRun4D128 \
    --no_exec \
    --python_filename=GSD_fragment.py

  # PU-aware GSD (mix module is instantiated with proper digitizer bunch
  # structure; mix.input.fileNames stays empty and gets filled at runtime
  # by GSD_GUN.py via the pu=<file> arg).
  cmsDriver.py SingleElectronPt10_pythia8_cfi \
    --conditions auto:phase2_realistic_T35 \
    -n 10 \
    --era Phase2C26I13M9 \
    --eventcontent FEVTDEBUG \
    -s GEN,SIM,DIGI:pdigi_valid,L1TrackTrigger,L1,L1P2GT,DIGI2RAW,HLT:@relvalRun4 \
    --datatier GEN-SIM-DIGI-RAW \
    --beamspot NoSmear \
    --geometry ExtendedRun4D128 \
    --pileup AVE_30_BX_25ns \
    --pileup_input file:minbias_placeholder.root \
    --no_exec \
    --python_filename=GSD_fragment_PU.py

  cmsDriver.py step4 \
    --conditions auto:phase2_realistic_T35 \
    -n 10 \
    --era Phase2C26I13M9 \
    --eventcontent FEVTDEBUG \
    --runUnscheduled \
    -s RAW2DIGI,L1Reco,RECO,RECOSIM \
    --datatier GEN-SIM-RECO \
    --geometry ExtendedRun4D128 \
    --no_exec \
    --python_filename=RECO_fragment.py

  cmsDriver.py step4 \
    --conditions auto:phase2_realistic_T35 \
    -n 10 \
    --era Phase2C26I13M9 \
    --eventcontent FEVTDEBUG \
    --runUnscheduled \
    -s RAW2DIGI,L1Reco,RECO,RECOSIM \
    --datatier GEN-SIM-RECO \
    --geometry ExtendedRun4D128 \
    --no_exec \
    --processName=NTUP \
    --python_filename=NTUP_fragment.py

}
action "$@"

# blank the placeholder pileup input (filled at runtime by GSD_GUN.py pu=<file>)
sed -i "s#cms.untracked.vstring(\['file:minbias_placeholder.root'\])#cms.untracked.vstring([])#" GSD_fragment_PU.py

