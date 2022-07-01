#include "TString.h"
#include "TTree.h"
#include "TFile.h"

#include <fstream>
#include <iostream>
#include <string>

void make_tree(TString path_to_tmp_file = "test01", TString out_file_name = "test01.root") {
    TTree* tree = new TTree("tree", "tree");
    long long int triger_counter = 0;
    long long int clock_counter = 0;
    long long int input_2ch_counter = 0;
    int fadc[4][1024] = {};
    int hit[128][1023] = {};
    tree->Branch("triger_counter", &triger_counter);
    tree->Branch("clock_counter", &clock_counter);
    tree->Branch("input_2ch_counter", &input_2ch_counter);
    tree->Branch("fadc", fadc, "fadc[4][1024]/I");
    tree->Branch("hit", hit, "hit[128][1023]/I");

    std::ifstream ifs(path_to_tmp_file);
    int buff1, buff2, buff3, buff4;
    while (1)
    {   
        if (ifs.eof()) break;
        ifs >> triger_counter
            >> clock_counter
            >> input_2ch_counter
            >> buff1
            >> buff2
            >> buff3
            >> buff4;
        for (int ch = 0; ch < 4; ch++) {
            for (int i = 0; i < 1024; i++) {
                ifs >> buff1;
                fadc[ch][i] = buff1;
            }
        }
        for (int i = 0; i < 1023; i++) {
            for (int ch = 0; ch < 128; ch++) {
                ifs >> buff1;
                hit[ch][i] = buff1;
            }
        }
        tree->Fill();
    }

    std::cout << tree->GetEntries() << std::endl;

    TFile* file = new TFile(out_file_name, "recreate");
    tree->Write();
    file->Close();
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: make_tree <inputfile> <outputfile>";
        exit(0);
    }
    std::string inputfile = argv[1];
    std::string outputfile = argv[2];
    make_tree(inputfile, outputfile);
}