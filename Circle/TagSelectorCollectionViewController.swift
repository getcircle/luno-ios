//
//  TagSelectorCollectionViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class TagSelectorCollectionViewController: UICollectionViewController {

    let tags = [
        "python", "mysql", "investing", "french", "ios", "swift", "business development", "private equity", "personal finance", "C", "C++", "product", "design",
        
        "mobile applications", "photoshop", "product marketing", "spanish", "human resources", "management", "startups", "productivity", "customer experience", "communication", "c#", "postgres", "android",
        
        "hadoop", "kafka", "big data", "mac os x", "API", "hiring", "recruiting", "objective-C", "java", "visual studio", "social media", "php", "html",
        
        "javaScript", "html5", "css", "mongodb", "advertising", "heroku", "AWS", "fundraising", "ruby on rails", "coffeeScript", "bash scripting", "ops", "software development",
        
        "ActionScript","C","C#","C++","Clojure","CoffeeScript","Common Lisp","CSS","Diff","Emacs Lisp","Erlang","Haskell","HTML","Java","JavaScript","Lua","Objective-C","Perl","PHP","Python","Ruby","Scala","Scheme","Shell","SQL","ABAP","Ada","Agda","AGS Script","Alloy","Ant Build System","ANTLR","ApacheConf","Apex","APL","AppleScript","Arc","Arduino","AsciiDoc","ASP","AspectJ","Assembly","ATS","Augeas","AutoHotkey","AutoIt","Awk","Batchfile","Befunge","Bison","BitBake","BlitzBasic","BlitzMax","Bluespec","Boo","Brainfuck","Brightscript","Bro","C-ObjDump","C2hs Haskell","Cap'n Proto","Ceylon","Chapel","ChucK","Cirru","Clean","CLIPS","CMake","COBOL","ColdFusion","ColdFusion CFC","Component Pascal","Cool","Coq","Cpp-ObjDump","Creole","Crystal","Cucumber","Cuda","Cycript","Cython","D","D-ObjDump","Darcs Patch","Dart","DM","Dockerfile","Dogescript","Dylan","E","Eagle","eC","Ecere Projects","ECL","edn","Eiffel","Elixir","Elm","EmberScript","F#","Factor","Fancy","Fantom","fish","FLUX","Forth","FORTRAN","Frege","G-code","Game Maker Language","GAMS","GAP","GAS","GDScript","Genshi","Gentoo Ebuild","Gentoo Eclass","Gettext Catalog","GLSL","Glyph","Gnuplot","Go","Golo","Gosu","Grace","Gradle","Grammatical Framework","Graph Modeling Language","Graphviz (DOT)","Groff","Groovy","Groovy Server Pages","Hack","Haml","Handlebars","Harbour","Haxe","HTML+Django","HTML+ERB","HTML+PHP","HTTP","Hy","IDL","Idris","IGOR Pro","Inform 7","INI","Inno Setup","Io","Ioke","IRC log","Isabelle","J","Jade","Jasmin","Java Server Pages","JSON","JSON5","JSONiq","JSONLD","Julia","Kit","Kotlin","KRL","LabVIEW","Lasso","Latte","Less","LFE","LilyPond","Liquid","Literate Agda","Literate CoffeeScript","Literate Haskell","LiveScript","LLVM","Logos","Logtalk","LOLCODE","LookML","LoomScript","LSL","M","Makefile","Mako","Markdown","Mask","Mathematica","Matlab","Maven POM","Max","MediaWiki","Mercury","MiniD","Mirah","Monkey","Moocode","MoonScript","MTML","mupad","Myghty","Nemerle","nesC","NetLogo","Nginx","Nimrod","Ninja","Nit","Nix","NSIS","Nu","NumPy","ObjDump","Objective-C++","Objective-J","OCaml","Omgrofl","ooc","Opa","Opal","OpenCL","OpenEdge ABL","OpenSCAD","Org","Ox","Oxygene","Oz","Pan","Papyrus","Parrot","Parrot Assembly","Parrot Internal Representation","Pascal","PAWN","Perl6","PigLatin","Pike","Pod","PogoScript","PostScript","PowerShell","Processing","Prolog","Propeller Spin","Protocol Buffer","Public Key","Puppet","Pure Data","PureBasic","PureScript","Python traceback","QMake","QML","R","Racket","Ragel in Ruby Host","RAML","Raw token data","RDoc","REALbasic","Rebol","Red","Redcode","reStructuredText","RHTML","RMarkdown","RobotFramework","Rouge","Rust","Sage","SAS","Sass","Scaml","Scilab","SCSS","Self","ShellSession","Shen","Slash","Slim","Smalltalk","Smarty","SourcePawn","SQF","Squirrel","Standard ML","Stata","STON","Stylus","SuperCollider","Swift","SystemVerilog","Tcl","Tcsh","Tea","TeX","Text","Textile","Thrift","TOML","Turing","Twig","TXL","TypeScript","Unified Parallel C","UnrealScript","Vala","VCL","Verilog","VHDL","VimL","Visual Basic","Volt","WebIDL","wisp","xBase","XC","XML","Xojo","XProc","XQuery","XS","XSLT","Xtend","YAML","Zephir","Zimpl",        
    ]
    var prototypeCell: TagCollectionViewCell!
    var animatedCell = [NSIndexPath: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init prototype cell
        let cellNibViews = NSBundle.mainBundle().loadNibNamed("TagCollectionViewCell", owner: self, options: nil)
        prototypeCell = cellNibViews.first as TagCollectionViewCell
        
        // Configurations
        configureCollectionView()
    }

    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView?.registerNib(
            UINib(nibName: "TagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: TagCollectionViewCell.classReuseIdentifier
        )
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TagCollectionViewCell.classReuseIdentifier, forIndexPath: indexPath) as TagCollectionViewCell
    
        // Configure the cell
        cell.tagLabel.text = tags[indexPath.row].capitalizedString
        
        if animatedCell[indexPath] == nil {
            animatedCell[indexPath] = true
            let originalFrame = cell.frame
            var cellFrame = originalFrame
            let collectionViewMidX = CGRectGetMidX(collectionView.frame)
            if CGRectGetMinX(cellFrame) < collectionViewMidX {
                // Animate from left
                cellFrame.origin.x -= 20.0
            }
            else {
                // Animate from right
                cellFrame.origin.x += 20.0
            }
            cell.frame = cellFrame
            cell.alpha = 0.0
            
            UIView.animateWithDuration(0.2,
                delay: 0.02 * Double(indexPath.row),
                options: .CurveEaseIn,
                animations: { () -> Void in
                    cell.frame = originalFrame
                    cell.alpha = 0.8
                },
                completion: nil
            )
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        prototypeCell.tagLabel.text = tags[indexPath.row].capitalizedString
        prototypeCell.setNeedsLayout()
        prototypeCell.layoutIfNeeded()
        return prototypeCell.intrinsicContentSize()
    }

    // MARK: - IBActions
    
    @IBAction func close(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
