//
//  TagSelectorViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class TagSelectorViewController: UIViewController,
                                 UISearchBarDelegate,
                                 UISearchResultsUpdating  {

    class var tags: [String] {
        return [
        "python", "mysql", "investing", "french", "ios", "swift", "business development", "private equity", "personal finance", "C", "C++", "product", "design",
        "mobile applications", "photoshop", "product marketing", "spanish", "human resources", "management", "startups", "productivity", "customer experience", "communication", "c#", "postgres", "android",
        "hadoop", "kafka", "big data", "mac os x", "API", "hiring", "recruiting", "objective-C", "java", "visual studio", "social media", "php", "html",
        "javaScript", "html5", "css", "mongodb", "advertising", "heroku", "AWS", "fundraising", "ruby on rails", "coffeeScript", "bash scripting", "ops", "software development",
        "ActionScript","C","C#","C++","Clojure","CoffeeScript","Common Lisp","CSS","Diff","Emacs Lisp","Erlang","Haskell","HTML","Java","JavaScript","Lua","Objective-C",
        "Perl","PHP","Python","Ruby","Scala","Scheme","Shell","SQL","ABAP","Ada","Agda","AGS Script","Alloy","Ant Build System","ANTLR","ApacheConf","Apex","APL","AppleScript","Arc","Arduino","AsciiDoc","ASP","AspectJ","Assembly","ATS","Augeas","AutoHotkey","AutoIt","Awk","Batchfile","Befunge","Bison","BitBake","BlitzBasic","BlitzMax","Bluespec","Boo","Brainfuck","Brightscript","Bro","C-ObjDump","C2hs Haskell","Cap'n Proto","Ceylon","Chapel","ChucK","Cirru","Clean","CLIPS","CMake","COBOL","ColdFusion","ColdFusion CFC","Component Pascal","Cool","Coq","Cpp-ObjDump","Creole","Crystal","Cucumber","Cuda","Cycript","Cython","D","D-ObjDump","Darcs Patch","Dart","DM","Dockerfile","Dogescript","Dylan","E","Eagle","eC","Ecere Projects","ECL","edn","Eiffel","Elixir","Elm","EmberScript","F#","Factor","Fancy","Fantom","fish","FLUX","Forth","FORTRAN","Frege","G-code","Game Maker Language","GAMS","GAP","GAS","GDScript","Genshi","Gentoo Ebuild","Gentoo Eclass","Gettext Catalog","GLSL","Glyph","Gnuplot","Go","Golo","Gosu","Grace","Gradle","Grammatical Framework","Graph Modeling Language","Graphviz (DOT)","Groff","Groovy","Groovy Server Pages","Hack","Haml","Handlebars","Harbour","Haxe","HTML+Django","HTML+ERB","HTML+PHP","HTTP","Hy","IDL","Idris","IGOR Pro","Inform 7","INI","Inno Setup","Io","Ioke","IRC log","Isabelle","J","Jade","Jasmin","Java Server Pages","JSON","JSON5","JSONiq","JSONLD","Julia","Kit","Kotlin","KRL","LabVIEW","Lasso","Latte","Less","LFE","LilyPond","Liquid","Literate Agda","Literate CoffeeScript","Literate Haskell","LiveScript","LLVM","Logos","Logtalk","LOLCODE","LookML","LoomScript","LSL","M","Makefile","Mako","Markdown","Mask","Mathematica","Matlab","Maven POM","Max","MediaWiki","Mercury","MiniD","Mirah","Monkey","Moocode","MoonScript","MTML","mupad","Myghty","Nemerle","nesC","NetLogo","Nginx","Nimrod","Ninja","Nit","Nix","NSIS","Nu","NumPy","ObjDump","Objective-C++","Objective-J","OCaml","Omgrofl","ooc","Opa","Opal","OpenCL","OpenEdge ABL","OpenSCAD","Org","Ox","Oxygene","Oz","Pan","Papyrus","Parrot","Parrot Assembly","Parrot Internal Representation","Pascal","PAWN","Perl6","PigLatin","Pike","Pod","PogoScript","PostScript","PowerShell","Processing","Prolog","Propeller Spin","Protocol Buffer","Public Key","Puppet","Pure Data","PureBasic","PureScript","Python traceback","QMake","QML","R","Racket","Ragel in Ruby Host","RAML","Raw token data","RDoc","REALbasic","Rebol","Red","Redcode","reStructuredText","RHTML","RMarkdown","RobotFramework","Rouge","Rust","Sage","SAS","Sass","Scaml","Scilab","SCSS","Self","ShellSession","Shen","Slash","Slim","Smalltalk","Smarty","SourcePawn","SQF","Squirrel","Standard ML","Stata","STON","Stylus","SuperCollider","Swift","SystemVerilog","Tcl","Tcsh","Tea","TeX","Text","Textile","Thrift","TOML","Turing","Twig","TXL","TypeScript","Unified Parallel C","UnrealScript","Vala","VCL","Verilog","VHDL","VimL","Visual Basic","Volt","WebIDL","wisp","xBase","XC","XML","Xojo","XProc","XQuery","XS","XSLT","Xtend","YAML","Zephir","Zimpl",
        ]}
    
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var searchControllerParentView: UIView!
    
    let gradientHeight: CGFloat = 60.0

    private var animatedCell = [NSIndexPath: Bool]()
    private var bottomLayer: CAGradientLayer!
    private var filteredTags = [String]()
    private var prototypeCell: TagCollectionViewCell!
    private var searchController: UISearchController!
    private var selectedTags = NSMutableSet()
    private var topLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configurations
        filteredTags = TagSelectorViewController.tags
        configureSearchController()
        configurePrototypeCell()
        configureCollectionView()
        configureGradients()
    }

    // MARK: - Configuration
    
    private func configurePrototypeCell() {
        // Init prototype cell
        let cellNibViews = NSBundle.mainBundle().loadNibNamed("TagCollectionViewCell", owner: self, options: nil)
        prototypeCell = cellNibViews.first as TagCollectionViewCell
    }
    
    private func configureCollectionView() {
        collectionView?.registerNib(
            UINib(nibName: "TagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: TagCollectionViewCell.classReuseIdentifier
        )
        
        collectionView?.allowsMultipleSelection = true
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Filter tags"
        searchController.searchBar.sizeToFit()
        searchControllerParentView.addSubview(searchController.searchBar)
        definesPresentationContext = true
    }
    
    private func configureGradients() {
        let startColor = UIColor.whiteColor().CGColor
        let endColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.0).CGColor
        
        // Top
        topLayer = CALayer.gradientLayerWithFrame(
            topGrientLayerFrame(),
            startColor: startColor,
            endColor: endColor
        )
        view.layer.addSublayer(topLayer)
        
        // Bottom
        bottomLayer = CALayer.gradientLayerWithFrame(
            bottomGradientLayerFrame(),
            startColor: endColor,
            endColor: startColor
        )
        view.layer.addSublayer(bottomLayer)
    }
    
    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTags.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TagCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as TagCollectionViewCell
    
        // Configure the cell
        cell.tagLabel.text = filteredTags[indexPath.row].capitalizedString
        if animatedCell[indexPath] == nil {
            animatedCell[indexPath] = true
            cell.animateForCollection(collectionView, atIndexPath: indexPath)
        }
        
        // Manage Selection
        if cell.selected {
            cell.selectCell(false)
        }
        else if selectedTags.containsObject(filteredTags[indexPath.row]) {
            cell.selectCell(false)
            cell.selected = true
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: nil)
        }
        else {
            cell.unHighlightCell(false)
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.highlightCell(true)
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.unHighlightCell(true)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.selectCell(true)
        selectedTags.addObject(filteredTags[indexPath.row])
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.unHighlightCell(true)
        selectedTags.removeObject(filteredTags[indexPath.row])
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        prototypeCell.tagLabel.text = filteredTags[indexPath.row].capitalizedString
        prototypeCell.setNeedsLayout()
        prototypeCell.layoutIfNeeded()
        return prototypeCell.intrinsicContentSize()
    }

    // MARK: - IBActions
    
    @IBAction func close(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let dataChanged = filteredTags.count != TagSelectorViewController.tags.count
        let searchString = searchController.searchBar.text
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let trimmedString = searchString.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        if trimmedString == "" {
            filteredTags = TagSelectorViewController.tags
        }
        else {
            
            var andPredicates = [NSPredicate]()
            var searchTerms = trimmedString.componentsSeparatedByString(" ")
            for searchTerm in searchTerms {
                var searchTermPredicates = [NSPredicate]()
                let trimmedSearchTerm = searchTerm.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
                
                // Match tag name
                var tagNamePredicate = NSComparisonPredicate(
                    leftExpression: NSExpression(forVariable: "tag"),
                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                    modifier: .DirectPredicateModifier,
                    type: .ContainsPredicateOperatorType,
                    options: .CaseInsensitivePredicateOption
                )

                andPredicates.append(tagNamePredicate)
            }
            
            let tags = TagSelectorViewController.tags
            let finalPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(andPredicates)
            filteredTags = tags.filter{ finalPredicate.evaluateWithObject($0, substitutionVariables: ["tag": $0]) }
        }
        
        if dataChanged {
            collectionView?.reloadData()
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Helpers
    
    private func topGrientLayerFrame() -> CGRect {
        return CGRectMake(10.0, searchControllerParentView.frameBottom, view.frameWidth - 20.0, gradientHeight)
    }
    
    private func bottomGradientLayerFrame() -> CGRect {
        return CGRectMake(10.0, view.frameHeight - gradientHeight + 10.0, view.frameWidth - 20.0, gradientHeight)
    }
}
