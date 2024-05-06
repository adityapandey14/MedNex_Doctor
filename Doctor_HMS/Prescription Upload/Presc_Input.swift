//
//  Presc_Input.swift
//  Doctor_HMS
//
//  Created by Arnav on 06/05/24.
//

import SwiftUI

struct AddPrescriptionView: View {
    @EnvironmentObject var viewModel: PrescriptionViewModel
    @State private var selectedPatient: String = ""
    @State private var medicines: [MedicineInput] = [MedicineInput()]
    @State private var instructions: String = ""
    
    var body: some View {
        VStack {
            Picker("Select Patient", selection: $selectedPatient) {
                ForEach(viewModel.patients, id: \.id) { patient in
                    Text(patient.name).tag(patient.id)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            ForEach(medicines.indices, id: \.self) { index in
                MedicineInputView(medicine: $medicines[index])
            }
            
            Button(action: {
                medicines.append(MedicineInput())
            }, label: {
                Text("Add Medicine")
            })
            
            TextField("Instructions", text: $instructions)
            
            Button("Add Prescription") {
                guard !selectedPatient.isEmpty && !medicines.isEmpty && !instructions.isEmpty else {
                    return
                }
                let medicineData = medicines.map { Medicine(name: $0.name, dosage: $0.dosage) }
                viewModel.addPrescription(patientID: selectedPatient, medicines: medicineData, instructions: instructions)
                
                // Clear fields after adding prescription
                selectedPatient = ""
                medicines = [MedicineInput()]
                instructions = ""
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchPatients()
        }
    }
}

struct MedicineInputView: View {
    @Binding var medicine: MedicineInput
    
    var body: some View {
        VStack {
            TextField("Medicine Name", text: $medicine.name)
            TextField("Dosage", text: $medicine.dosage)
        }
    }
}

struct MedicineInput {
    var name: String = ""
    var dosage: String = ""
}
