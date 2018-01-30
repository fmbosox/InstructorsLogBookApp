//
//  PDFViewerViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 1/10/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {
    
    var pdfDocument: PDFDocument!

    override func viewDidLoad() {
        super.viewDidLoad()
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.frame = self.view.bounds
        pdfView.document = pdfDocument
        self.view.addSubview(pdfView)
    }

    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [pdfDocument.dataRepresentation()!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        self.present(activityViewController, animated: true, completion: nil)
        
    }

}
