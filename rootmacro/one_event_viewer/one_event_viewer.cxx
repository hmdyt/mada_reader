#include "TGraph.h"
#include "TTree.h"
#include "TString.h"
#include "TFile.h"
#include "TCanvas.h"

#include <iostream>

void is_valid_target_event(int n_entries, int i_event) {
    if (n_entries < i_event) {
        TString msg = Form("i_event is too large, should be less than %d", n_entries);
        std::cerr << msg.Data() << std::endl;
        exit(1);
    }
}

int main(int argc, char* argv[]) {
    if (argc != 4) {
        std::cerr << "Usage: one_event_viewer <root_file> <tree_name> <i_event>";
        exit(1);
    }
    TString root_file_name = argv[1];
    TString tree_name = argv[2];
    int i_event = ((TString)argv[3]).Atoi();
    int fadc[4][1024];
    int hit[128][1023];
    TTree* tree = (TTree*)(TFile::Open(root_file_name)->Get(tree_name.Data()));
    tree->SetBranchAddress("fadc", fadc);
    tree->SetBranchAddress("hit", hit);
    int n_entries = tree->GetEntries();
    is_valid_target_event(n_entries, i_event);
    tree->GetEntry(i_event);

    TGraph* g = new TGraph();
    for (int i = 0; i < 1024; i++) {
        for (int ch = 0; ch < 4; ch++) {
            g->SetPoint(g->GetN(), i, fadc[ch][i]);
        }
    }
    
    TCanvas* c = new TCanvas();
    g->Draw("AP");
    c->SaveAs("one_event_viewer.png");

    return 0;
}