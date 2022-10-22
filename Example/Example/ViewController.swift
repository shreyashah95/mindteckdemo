//
//  ViewController.swift
//  Example
//
//  Created by Shreya Shah on 20/10/22.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var vw_Tableview: UITableView!
    @IBOutlet weak var pagecontrol_Collection: UIPageControl!
    @IBOutlet weak var vw_Collection: UICollectionView!
    @IBOutlet weak var vw_Scroll: UIScrollView!
    
    var Categoryarr = [#imageLiteral(resourceName: "C2") , #imageLiteral(resourceName: "C3") , #imageLiteral(resourceName: "C1")]
    var mainarray : NSMutableArray = []
    let vegetablesarray = ["Tamato" , "Patato" , "cabbage","Tamato" , "Patato" , "cabbage","Tamato" , "Patato" , "cabbage","Tamato" , "Patato" , "cabbage","Tamato" , "Patato" , "cabbage"]
    let fruitsarray = ["Mango" , "banana" , "apple","Mango" , "banana" , "apple","Mango" , "banana" , "apple","Mango" , "banana" , "apple","Mango" , "banana" , "apple","Mango" , "banana" , "apple","Mango" , "banana" , "apple"]
    let abcarr = ["abc" , "xyz" , "pqr","abc" , "xyz" , "pqr","abc" , "xyz" , "pqr","abc" , "xyz" , "pqr","abc" , "xyz" , "pqr"]
    
    var lastContentOffset = 0.0
    var currentarray : [String] = []
    var applyarr : [String] = []
    
    var currentindex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControls()
        mainarray = [fruitsarray , vegetablesarray , abcarr]
        currentarray = mainarray[0] as! [String]
        applyarr = currentarray

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        tblHeight.constant = UIScreen.main.bounds.height - 60
        vw_Scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: tblHeight.constant + topView.bounds.height)
    }
    func setupControls()
    {
        vw_Collection.delegate = self
        vw_Collection.dataSource = self
        vw_Tableview.delegate = self
        vw_Tableview.dataSource = self
        vw_Scroll.delegate = self
        vw_Tableview.isScrollEnabled = false
        pagecontrol_Collection.currentPage = 0

    }
    
    func scrollchange(index : Int)
    {
        applyarr.removeAll()
        currentarray = mainarray[index] as! [String]
        applyarr = mainarray[index] as! [String]
        vw_Tableview.reloadData()
        pagecontrol_Collection.numberOfPages = mainarray.count
        pagecontrol_Collection.currentPage = index
    }
}


extension ViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredArray = currentarray.filter { ($0 ).range(of: searchText, options: [.diacriticInsensitive, .caseInsensitive]) != nil }
        if(searchText == "")
        {
            applyarr = currentarray
        }else{
            applyarr = filteredArray
        }
        vw_Tableview.reloadData()
        searchBar.becomeFirstResponder()
    }

}
extension ViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == vw_Scroll)
        {
            if(scrollView.contentOffset.y >= 262)
            {
                vw_Tableview.isScrollEnabled = true
                vw_Scroll.isScrollEnabled = false
            }
        }
        if(scrollView == vw_Tableview)
        {
            if(scrollView.contentOffset.y <= 0)
            {
                vw_Tableview.isScrollEnabled = false
                vw_Scroll.isScrollEnabled = true
            }
        }
        if(scrollView == vw_Collection)
        {
            let scrollpos = scrollView.contentOffset.x / vw_Collection.frame.width
            pagecontrol_Collection.currentPage = Int(scrollpos)
            scrollchange(index: Int(scrollpos))
        }
    }
    

}

extension ViewController : UITableViewDelegate ,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applyarr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell")! as UITableViewCell
        let label = cell.viewWithTag(101) as? UILabel
        label?.text = applyarr[indexPath.row] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")! as UITableViewCell
        let searchbar = cell.viewWithTag(101) as? UISearchBar
        searchbar?.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainarray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as UICollectionViewCell
        let imageview = cell.viewWithTag(101) as! UIImageView
        imageview.contentMode = .scaleToFill
        imageview.image = Categoryarr[indexPath.row]
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width , height: collectionView.frame.height)
    }
}
