//
//  CompositeDataSourceMultiSectionCollectionTests.swift
//  GenericDataSource
//
//  Created by Mohamed Afifi on 2/28/16.
//  Copyright © 2016 mohamede1945. All rights reserved.
//

import XCTest
@testable import GenericDataSource

class CompositeDataSourceMultiSectionCollectionTests: XCTestCase {
    
    func testItemSize()  {
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        let dataSource  = CompositeDataSource(type: .MultiSection)
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: 50)
        dataSource.addDataSource(pdfReportsDataSource)
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(numberOfReports: 200)
        dataSource.addDataSource(textReportsDataSource)
        
        let size1 = CGSize(width: 10, height: 20)
        let size2 = CGSize(width: 70, height: 1200)
        pdfReportsDataSource.itemSize = size1
        textReportsDataSource.itemSize = size2
        
        XCTAssertEqual(size1, dataSource.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)))
        XCTAssertEqual(size1, dataSource.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAtIndexPath: NSIndexPath(forItem: 49, inSection: 0)))
        XCTAssertEqual(size2, dataSource.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAtIndexPath: NSIndexPath(forItem: 50, inSection: 1)))
        XCTAssertEqual(size2, dataSource.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAtIndexPath: NSIndexPath(forItem: 100, inSection: 1)))
    }
    
    func testSelectorConfigureCell()  {
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        let dataSource  = CompositeDataSource(type: .MultiSection)
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: 50)
        dataSource.addDataSource(pdfReportsDataSource)
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(numberOfReports: 200)
        dataSource.addDataSource(textReportsDataSource)
        
        // register the cell
        pdfReportsDataSource.registerReusableViewsInCollectionView(collectionView)
        textReportsDataSource.registerReusableViewsInCollectionView(collectionView)
        
        let selector1 = MockSelectionController<Report, PDFReportCollectionViewCell>()
        let selector2 = MockSelectionController<Report, TextReportCollectionViewCell>()
        
        pdfReportsDataSource.selectionHandler = selector1.anyDataSourceSelectionHandler()
        textReportsDataSource.selectionHandler = selector2.anyDataSourceSelectionHandler()
        
        var index = NSIndexPath(forItem: 0, inSection: 0)
        var cell = dataSource.collectionView(collectionView, cellForItemAtIndexPath: index)
        XCTAssertTrue(selector1.configureCellCalled)
        XCTAssertEqual(cell, selector1.cell)
        XCTAssertEqual(pdfReportsDataSource.items[index.item], selector1.item)
        XCTAssertEqual(index, selector1.indexPath)
        XCTAssertFalse(selector2.configureCellCalled)
        selector1.configureCellCalled = false
        
        index = NSIndexPath(forItem: 49, inSection: 0)
        cell = dataSource.collectionView(collectionView, cellForItemAtIndexPath: index)
        XCTAssertTrue(selector1.configureCellCalled)
        XCTAssertEqual(cell, selector1.cell)
        XCTAssertEqual(pdfReportsDataSource.items[index.item], selector1.item)
        XCTAssertEqual(index, selector1.indexPath)
        XCTAssertFalse(selector2.configureCellCalled)
        selector1.configureCellCalled = false
        
        index = NSIndexPath(forItem: 50, inSection: 1)
        cell = dataSource.collectionView(collectionView, cellForItemAtIndexPath: index)
        XCTAssertTrue(selector2.configureCellCalled)
        XCTAssertEqual(cell, selector2.cell)
        var localIndex = NSIndexPath(forItem: index.item, inSection: index.section - 1)
        XCTAssertEqual(textReportsDataSource.items[localIndex.item], selector2.item)
        XCTAssertEqual(localIndex, selector2.indexPath)
        XCTAssertFalse(selector1.configureCellCalled)
        selector2.configureCellCalled = false
        
        index = NSIndexPath(forItem: 150, inSection: 1)
        cell = dataSource.collectionView(collectionView, cellForItemAtIndexPath: index)
        XCTAssertTrue(selector2.configureCellCalled)
        XCTAssertEqual(cell, selector2.cell)
        localIndex = NSIndexPath(forItem: index.item, inSection: index.section - 1)
        XCTAssertEqual(textReportsDataSource.items[localIndex.item], selector2.item)
        XCTAssertEqual(localIndex, selector2.indexPath)
        XCTAssertFalse(selector1.configureCellCalled)
        selector2.configureCellCalled = false
    }
    
    func testShouldHighlight()  {
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        let dataSource  = CompositeDataSource(type: .MultiSection)
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: 50)
        dataSource.addDataSource(pdfReportsDataSource)
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(numberOfReports: 200)
        dataSource.addDataSource(textReportsDataSource)
        
        let selector1 = MockSelectionController<Report, PDFReportCollectionViewCell>()
        let selector2 = MockSelectionController<Report, TextReportCollectionViewCell>()
        
        pdfReportsDataSource.selectionHandler = selector1.anyDataSourceSelectionHandler()
        textReportsDataSource.selectionHandler = selector2.anyDataSourceSelectionHandler()
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldHighlightItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)))
        XCTAssertTrue(selector1.shouldHighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 0, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.shouldHighlightCalled)
        selector1.shouldHighlightCalled = false
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldHighlightItemAtIndexPath: NSIndexPath(forItem: 49, inSection: 0)))
        XCTAssertTrue(selector1.shouldHighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 49, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.shouldHighlightCalled)
        selector1.shouldHighlightCalled = false
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldHighlightItemAtIndexPath: NSIndexPath(forItem: 50, inSection: 1)))
        XCTAssertTrue(selector2.shouldHighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 50, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.shouldHighlightCalled)
        selector2.shouldHighlightCalled = false
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldHighlightItemAtIndexPath: NSIndexPath(forItem: 150, inSection: 1)))
        XCTAssertTrue(selector2.shouldHighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 150, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.shouldHighlightCalled)
        selector2.shouldHighlightCalled = false
    }
    
    func testDidHighlight()  {
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        let dataSource  = CompositeDataSource(type: .MultiSection)
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: 50)
        dataSource.addDataSource(pdfReportsDataSource)
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(numberOfReports: 200)
        dataSource.addDataSource(textReportsDataSource)
        
        let selector1 = MockSelectionController<Report, PDFReportCollectionViewCell>()
        let selector2 = MockSelectionController<Report, TextReportCollectionViewCell>()
        
        pdfReportsDataSource.selectionHandler = selector1.anyDataSourceSelectionHandler()
        textReportsDataSource.selectionHandler = selector2.anyDataSourceSelectionHandler()
        
        dataSource.collectionView(collectionView, didHighlightItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertTrue(selector1.didHighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 0, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.didHighlightCalled)
        selector1.didHighlightCalled = false
        
        dataSource.collectionView(collectionView, didHighlightItemAtIndexPath: NSIndexPath(forItem: 49, inSection: 0))
        XCTAssertTrue(selector1.didHighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 49, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.didHighlightCalled)
        selector1.didHighlightCalled = false
        
        dataSource.collectionView(collectionView, didHighlightItemAtIndexPath: NSIndexPath(forItem: 50, inSection: 1))
        XCTAssertTrue(selector2.didHighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 50, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.didHighlightCalled)
        selector2.didHighlightCalled = false
        
        dataSource.collectionView(collectionView, didHighlightItemAtIndexPath: NSIndexPath(forItem: 150, inSection: 1))
        XCTAssertTrue(selector2.didHighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 150, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.didHighlightCalled)
        selector2.didHighlightCalled = false
    }
    
    func testDidUnhighlight()  {
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        let dataSource  = CompositeDataSource(type: .MultiSection)
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: 50)
        dataSource.addDataSource(pdfReportsDataSource)
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(numberOfReports: 200)
        dataSource.addDataSource(textReportsDataSource)
        
        let selector1 = MockSelectionController<Report, PDFReportCollectionViewCell>()
        let selector2 = MockSelectionController<Report, TextReportCollectionViewCell>()
        
        pdfReportsDataSource.selectionHandler = selector1.anyDataSourceSelectionHandler()
        textReportsDataSource.selectionHandler = selector2.anyDataSourceSelectionHandler()
        
        dataSource.collectionView(collectionView, didUnhighlightItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertTrue(selector1.didUnhighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 0, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.didUnhighlightCalled)
        selector1.didUnhighlightCalled = false
        
        dataSource.collectionView(collectionView, didUnhighlightItemAtIndexPath: NSIndexPath(forItem: 49, inSection: 0))
        XCTAssertTrue(selector1.didUnhighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 49, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.didUnhighlightCalled)
        selector1.didUnhighlightCalled = false
        
        dataSource.collectionView(collectionView, didUnhighlightItemAtIndexPath: NSIndexPath(forItem: 50, inSection: 1))
        XCTAssertTrue(selector2.didUnhighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 50, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.didUnhighlightCalled)
        selector2.didUnhighlightCalled = false
        
        dataSource.collectionView(collectionView, didUnhighlightItemAtIndexPath: NSIndexPath(forItem: 150, inSection: 1))
        XCTAssertTrue(selector2.didUnhighlightCalled)
        XCTAssertEqual(NSIndexPath(forItem: 150, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.didUnhighlightCalled)
        selector2.didUnhighlightCalled = false
    }
    
    func testShouldSelect()  {
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        let dataSource  = CompositeDataSource(type: .MultiSection)
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: 50)
        dataSource.addDataSource(pdfReportsDataSource)
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(numberOfReports: 200)
        dataSource.addDataSource(textReportsDataSource)
        
        let selector1 = MockSelectionController<Report, PDFReportCollectionViewCell>()
        let selector2 = MockSelectionController<Report, TextReportCollectionViewCell>()
        
        pdfReportsDataSource.selectionHandler = selector1.anyDataSourceSelectionHandler()
        textReportsDataSource.selectionHandler = selector2.anyDataSourceSelectionHandler()
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)))
        XCTAssertTrue(selector1.shouldSelectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 0, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.shouldSelectCalled)
        selector1.shouldSelectCalled = false
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldSelectItemAtIndexPath: NSIndexPath(forItem: 49, inSection: 0)))
        XCTAssertTrue(selector1.shouldSelectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 49, inSection:0), selector1.indexPath)
        XCTAssertFalse(selector2.shouldSelectCalled)
        selector1.shouldSelectCalled = false
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldSelectItemAtIndexPath: NSIndexPath(forItem: 50, inSection: 1)))
        XCTAssertTrue(selector2.shouldSelectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 50, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.shouldSelectCalled)
        selector2.shouldSelectCalled = false
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldSelectItemAtIndexPath: NSIndexPath(forItem: 150, inSection: 1)))
        XCTAssertTrue(selector2.shouldSelectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 150, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.shouldSelectCalled)
        selector2.shouldSelectCalled = false
    }
    
    func testDidSelect()  {
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        let dataSource  = CompositeDataSource(type: .MultiSection)
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: 50)
        dataSource.addDataSource(pdfReportsDataSource)
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(numberOfReports: 200)
        dataSource.addDataSource(textReportsDataSource)
        
        let selector1 = MockSelectionController<Report, PDFReportCollectionViewCell>()
        let selector2 = MockSelectionController<Report, TextReportCollectionViewCell>()
        
        pdfReportsDataSource.selectionHandler = selector1.anyDataSourceSelectionHandler()
        textReportsDataSource.selectionHandler = selector2.anyDataSourceSelectionHandler()
        
        dataSource.collectionView(collectionView, didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertTrue(selector1.didSelectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 0, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.didSelectCalled)
        selector1.didSelectCalled = false
        
        dataSource.collectionView(collectionView, didSelectItemAtIndexPath: NSIndexPath(forItem: 49, inSection: 0))
        XCTAssertTrue(selector1.didSelectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 49, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.didSelectCalled)
        selector1.didSelectCalled = false
        
        dataSource.collectionView(collectionView, didSelectItemAtIndexPath: NSIndexPath(forItem: 50, inSection: 1))
        XCTAssertTrue(selector2.didSelectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 50, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.didSelectCalled)
        selector2.didSelectCalled = false
        
        dataSource.collectionView(collectionView, didSelectItemAtIndexPath: NSIndexPath(forItem: 150, inSection: 1))
        XCTAssertTrue(selector2.didSelectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 150, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.didSelectCalled)
        selector2.didSelectCalled = false
    }
    
    func testShouldDeselect()  {
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        let dataSource  = CompositeDataSource(type: .MultiSection)
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: 50)
        dataSource.addDataSource(pdfReportsDataSource)
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(numberOfReports: 200)
        dataSource.addDataSource(textReportsDataSource)
        
        let selector1 = MockSelectionController<Report, PDFReportCollectionViewCell>()
        let selector2 = MockSelectionController<Report, TextReportCollectionViewCell>()
        
        pdfReportsDataSource.selectionHandler = selector1.anyDataSourceSelectionHandler()
        textReportsDataSource.selectionHandler = selector2.anyDataSourceSelectionHandler()
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldDeselectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0)))
        XCTAssertTrue(selector1.shouldDeselectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 0, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.shouldDeselectCalled)
        selector1.shouldDeselectCalled = false
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldDeselectItemAtIndexPath: NSIndexPath(forItem: 49, inSection: 0)))
        XCTAssertTrue(selector1.shouldDeselectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 49, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.shouldDeselectCalled)
        selector1.shouldDeselectCalled = false
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldDeselectItemAtIndexPath: NSIndexPath(forItem: 50, inSection: 1)))
        XCTAssertTrue(selector2.shouldDeselectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 50, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.shouldDeselectCalled)
        selector2.shouldDeselectCalled = false
        
        XCTAssertTrue(dataSource.collectionView(collectionView, shouldDeselectItemAtIndexPath: NSIndexPath(forItem: 150, inSection: 1)))
        XCTAssertTrue(selector2.shouldDeselectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 150, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.shouldDeselectCalled)
        selector2.shouldDeselectCalled = false
    }
    
    func testDidDeselect()  {
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        let dataSource  = CompositeDataSource(type: .MultiSection)
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: 50)
        dataSource.addDataSource(pdfReportsDataSource)
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(numberOfReports: 200)
        dataSource.addDataSource(textReportsDataSource)
        
        let selector1 = MockSelectionController<Report, PDFReportCollectionViewCell>()
        let selector2 = MockSelectionController<Report, TextReportCollectionViewCell>()
        
        pdfReportsDataSource.selectionHandler = selector1.anyDataSourceSelectionHandler()
        textReportsDataSource.selectionHandler = selector2.anyDataSourceSelectionHandler()
        
        dataSource.collectionView(collectionView, didDeselectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertTrue(selector1.didDeselectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 0, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.didDeselectCalled)
        selector1.didDeselectCalled = false
        
        dataSource.collectionView(collectionView, didDeselectItemAtIndexPath: NSIndexPath(forItem: 49, inSection: 0))
        XCTAssertTrue(selector1.didDeselectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 49, inSection: 0), selector1.indexPath)
        XCTAssertFalse(selector2.didDeselectCalled)
        selector1.didDeselectCalled = false
        
        dataSource.collectionView(collectionView, didDeselectItemAtIndexPath: NSIndexPath(forItem: 50, inSection: 1))
        XCTAssertTrue(selector2.didDeselectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 50, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.didDeselectCalled)
        selector2.didDeselectCalled = false
        
        dataSource.collectionView(collectionView, didDeselectItemAtIndexPath: NSIndexPath(forItem: 150, inSection: 1))
        XCTAssertTrue(selector2.didDeselectCalled)
        XCTAssertEqual(NSIndexPath(forItem: 150, inSection: 0), selector2.indexPath)
        XCTAssertFalse(selector1.didDeselectCalled)
        selector2.didDeselectCalled = false
    }
    
    func testOneDataSource() {
        
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.numberOfReuseCells = 10
        
        let reportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        
        let reports = Report.generate(numberOfReports: 200)
        reportsDataSource.items = reports
        
        let dataSource  = CompositeDataSource(type: .MultiSection)
        dataSource.addDataSource(reportsDataSource)
        
        // assign as data source
        collectionView.dataSource = dataSource
        
        // register the cell
        reportsDataSource.registerReusableViewsInCollectionView(collectionView)
        
        // execute the test
        collectionView.queryDataSource()
        
        // assert
        XCTAssertEqual(1, dataSource.dataSources.count)
        XCTAssertTrue(reportsDataSource === dataSource.dataSources[0])
        XCTAssertEqual(1, collectionView.numberOfSections())
        XCTAssertEqual(reports.count, collectionView.numberOfItemsInSection(0))
        let cells = collectionView.cells[0] as! [TextReportCollectionViewCell]
        
        for (index, cell) in cells.enumerate() {
            XCTAssertTrue(cell.reports.contains(Report(id: index + 1, name: "report-\(index + 1)")), "Invalid report at index: \(index)")
            XCTAssertTrue(cell.indexPaths.contains(NSIndexPath(forItem: index, inSection: 0)), "Invalid index path at index: \(index)")
            
        }
    }
    
    func testDistinctCells() {
        
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.numberOfReuseCells = 10
        
        let total = 55
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: total / 2, name: "pdf report")
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(from: total / 2 + 1, numberOfReports: total, name: "text report")
        
        let dataSource  = CompositeDataSource(type: .MultiSection)
        dataSource.addDataSource(pdfReportsDataSource)
        dataSource.addDataSource(textReportsDataSource)
        
        // assign as data source
        collectionView.dataSource = dataSource
        
        // register the cell
        pdfReportsDataSource.registerReusableViewsInCollectionView(collectionView)
        textReportsDataSource.registerReusableViewsInCollectionView(collectionView)
        
        // execute the test
        collectionView.queryDataSource()
        
        // assert
        XCTAssertEqual(2, dataSource.dataSources.count)
        XCTAssertTrue(pdfReportsDataSource === dataSource.dataSources[0])
        XCTAssertTrue(textReportsDataSource === dataSource.dataSources[1])
        XCTAssertEqual(2, collectionView.numberOfSections())
        XCTAssertEqual(pdfReportsDataSource.items.count, collectionView.numberOfItemsInSection(0))
        XCTAssertEqual(textReportsDataSource.items.count, collectionView.numberOfItemsInSection(1))
        
        let cells1 = collectionView.cells[0]
        for (index, cell) in cells1.enumerate() {
            guard let cell = cell as? PDFReportCollectionViewCell else {
                XCTFail("Invalid cell type at index: \(index)")
                return
            }
            XCTAssertTrue(cell.reports.contains(Report(id: index + 1, name: "pdf report-\(index + 1)")), "Invalid report at index: \(index)")
            XCTAssertTrue(cell.indexPaths.contains(NSIndexPath(forItem: index, inSection: 0)), "Invalid index path at index: \(index)")
        }

        let cells2 = collectionView.cells[1]
        for (index, cell) in cells2.enumerate() {
            guard let cell = cell as? TextReportCollectionViewCell else {
                XCTFail("Invalid cell type at index: \(index)")
                return
            }
            XCTAssertTrue(cell.reports.contains(Report(id: index + 1 + total / 2, name: "text report-\(index + 1 + total / 2)")), "Invalid report at index: \(index)")
            XCTAssertTrue(cell.indexPaths.contains(NSIndexPath(forItem: index, inSection: 0)), "Invalid index path at index: \(index)")
        }
    }

    func testDistinctCellsWithSingleSection() {
        
        let collectionView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.numberOfReuseCells = 10
        
        let total = 55
        
        let pdfReportsDataSource = ReportBasicDataSource<PDFReportCollectionViewCell>()
        pdfReportsDataSource.items = Report.generate(numberOfReports: total / 2, name: "pdf report")
        
        let textReportsDataSource = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource.items = Report.generate(from: total / 2 + 1, numberOfReports: total, name: "text report")
        
        let singleSectionDataSource  = CompositeDataSource(type: .SingleSection)
        singleSectionDataSource.addDataSource(pdfReportsDataSource)
        singleSectionDataSource.addDataSource(textReportsDataSource)
        
        let textReportsDataSource2 = ReportBasicDataSource<TextReportCollectionViewCell>()
        textReportsDataSource2.items = Report.generate(numberOfReports: total, name: "another report")
        
        let dataSource  = CompositeDataSource(type: .MultiSection)
        dataSource.addDataSource(singleSectionDataSource)
        dataSource.addDataSource(textReportsDataSource2)
        
        // assign as data source
        collectionView.dataSource = dataSource
        
        // register the cell
        pdfReportsDataSource.registerReusableViewsInCollectionView(collectionView)
        textReportsDataSource.registerReusableViewsInCollectionView(collectionView)
        
        // execute the test
        collectionView.queryDataSource()
        
        // assert
        XCTAssertEqual(2, dataSource.dataSources.count)
        XCTAssertTrue(singleSectionDataSource === dataSource.dataSources[0])
        XCTAssertTrue(textReportsDataSource2 === dataSource.dataSources[1])
        XCTAssertEqual(2, collectionView.numberOfSections())
        XCTAssertEqual(pdfReportsDataSource.items.count + textReportsDataSource.items.count, collectionView.ds_numberOfItemsInSection(0))
        XCTAssertEqual(textReportsDataSource2.items.count, collectionView.ds_numberOfItemsInSection(1))
        let cells1 = collectionView.cells[0]
        
        for (index, cell) in cells1.enumerate() {
            if index < total / 2 {
                guard let cell = cell as? PDFReportCollectionViewCell else {
                    XCTFail("Invalid cell type at index: \(index)")
                    return
                }
                XCTAssertTrue(cell.reports.contains(Report(id: index + 1, name: "pdf report-\(index + 1)")), "Invalid report at index: \(index)")
                XCTAssertTrue(cell.indexPaths.contains(NSIndexPath(forItem: index, inSection: 0)), "Invalid index path at index: \(index)")
            } else {
                guard let cell = cell as? TextReportCollectionViewCell else {
                    XCTFail("Invalid cell type at index: \(index)")
                    return
                }
                XCTAssertTrue(cell.reports.contains(Report(id: index + 1, name: "text report-\(index + 1)")), "Invalid report at index: \(index)")
                XCTAssertTrue(cell.indexPaths.contains(NSIndexPath(forItem: index - total / 2, inSection: 0)), "Invalid index path at index: \(index)")
            }
        }
        
        let cells2 = collectionView.cells[1]
        for (index, cell) in cells2.enumerate() {
            guard let cell = cell as? TextReportCollectionViewCell else {
                XCTFail("Invalid cell type at index: \(index)")
                return
            }
            XCTAssertTrue(cell.reports.contains(Report(id: index + 1, name: "another report-\(index + 1)")), "Invalid report at index: \(index)")
            XCTAssertTrue(cell.indexPaths.contains(NSIndexPath(forItem: index, inSection: 0)), "Invalid index path at index: \(index)")
        }
    }
}
