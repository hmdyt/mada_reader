#include "TGraph.h"
#include "TTree.h"
#include "TString.h"
#include "TFile.h"
#include "TCanvas.h"
#include "TH2F.h"

#include <iostream>
#include <vector>

constexpr double FADC_MARKERSIZE = 0.15;
constexpr double FADC_VIEW_OFFSET = -530;
constexpr double FADC_SCALE = 0.1;

void is_valid_target_event(int n_entries, int i_event) {
    if (n_entries < i_event) {
        TString msg = Form("i_event is too large, should be less than %d", n_entries);
        std::cerr << msg.Data() << std::endl;
        exit(1);
    }
}

std::vector<TGraph*> init_fadc_TGraphs() {
    std::vector<TGraph*> ret(4);
    for (int i = 0; i < 4; i++) {
        ret.at(i) = new TGraph();
        ret.at(i)->SetMarkerSize(FADC_MARKERSIZE);
        ret.at(i)->SetMarkerStyle(8);
        ret.at(i)->SetMarkerColor(1);
    }
    return ret;
}

TGraph* init_hit_TGraph() {
    TGraph* ret = new TGraph();
    ret->SetMarkerSize(0.2);
    ret->SetMarkerStyle(21);
    ret->SetMarkerColor(2);
    return ret;
}

TH2F* init_axis(TString title){
    TH2F* ret = new TH2F(
        "image",
        title,
        128, -0.5, 127.5,
        1050, -0.5, 1049.5
    );
    ret->SetStats(0);
    return ret;
}

int main(int argc, char* argv[]) {
    // argument parse
    if (argc != 4) {
        std::cerr << "Usage: one_event_viewer <root_file> <tree_name> <i_event>";
        exit(1);
    }
    TString root_file_name = argv[1];
    TString tree_name = argv[2];
    int i_event = ((TString)argv[3]).Atoi();

    // init tree
    int fadc[4][1024];
    int hit[128][1023];
    TTree* tree = (TTree*)(TFile::Open(root_file_name)->Get(tree_name.Data()));
    tree->SetBranchAddress("fadc", fadc);
    tree->SetBranchAddress("hit", hit);
    int n_entries = tree->GetEntries();
    is_valid_target_event(n_entries, i_event);
    tree->GetEntry(i_event);

    // fadc graph
    std::vector<TGraph*> fadc_graphs = init_fadc_TGraphs();
    for (int clock = 0; clock < 1024; clock++) {
        for (int ch = 0; ch < 4; ch++) {
            double channel_offset = 20 + 30 * ch;
            fadc_graphs.at(ch)->SetPoint(
                    fadc_graphs.at(ch)->GetN(),
                    FADC_SCALE * (fadc[ch][clock] + FADC_VIEW_OFFSET) + channel_offset,
                    clock
                );
        }
    }

    // hit draw
    TGraph* hit_graph = init_hit_TGraph();
    for (int clock = 0; clock < 1023; clock++) {
        for (int ch = 0; ch < 128; ch++) {
            if (hit[ch][clock] == 0) continue;
            hit_graph->SetPoint(
                hit_graph->GetN(),
                ch,
                clock
            );
        }
    }

    
    // draw
    TString axis_title = Form(
        "%s #%d;StripID;Clock",
        root_file_name.Data(),
        i_event
    );
    TH2F* axis = init_axis(axis_title);
    TCanvas* c = new TCanvas();
    axis->Draw("AXIS");
    fadc_graphs.at(0)->Draw("L SAME");
    fadc_graphs.at(1)->Draw("L SAME");
    fadc_graphs.at(2)->Draw("L SAME");
    fadc_graphs.at(3)->Draw("L SAME");
    hit_graph->Draw("P SAME");
    c->SaveAs("one_event_viewer.png");

    return 0;
}