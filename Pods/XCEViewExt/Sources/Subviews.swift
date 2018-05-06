/*
 
 MIT License
 
 Copyright (c) 2016 Maxim Khatskevich (maxim@khatskevi.ch)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

import UIKit

//---

public
protocol ViewContainer { }

//---

extension UIView: ViewContainer { }

//---

public
extension ViewContainer where Self: UIView
{
    @discardableResult
    func addSubviews(_ views: UIView...) -> UIView
    {
        views.forEach { self.addSubview($0) }
        
        //---
        
        return self
    }
}

//---

@available(iOS 9.0, *)
public
extension ViewContainer where Self: UIStackView
{
    @discardableResult
    func addSubviews(_ views: UIView...) -> UIStackView
    {
        views.forEach { self.addArrangedSubview($0) }
        
        //---
        
        return self
    }
}

//---

public
extension UIView
{
    func removeAllConstraints()
    {
        removeConstraints(constraints)
    }
}

//---

public
extension UIView
{
    func allSubviews() -> [UIView]
    {
        var result: [UIView] = []
        
        //---
        
        collectAllSubviews(into: &result)
        
        //---
        
        return result
    }
    
    //---
    
    private
    func collectAllSubviews(into list: inout [UIView])
    {
        for sv in subviews
        {
            list.append(sv)
            
            //---
            
            sv.collectAllSubviews(into: &list)
        }
    }
}
