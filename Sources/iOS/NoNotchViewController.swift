import UIKit

import SnapKit

//---

public
class NoNotchView: UIView
{
    public
    static
    var isScreenWithNotch: Bool
    {
        // iPhoneX?
        return UIScreen.main.bounds.size
            == CGSize(width: 375, height: 812)
    }

    public
    static
    var appAreaCornerRadius: CGFloat
    {
        return isScreenWithNotch ? 22 : 8
    }

    //---

    public
    let contentView = UIView()

    //---

    override
    init(frame: CGRect)
    {
        super.init(frame: frame)

        //--- hierarchy

        addSubview(
            contentView
        )

        //--- layout

        contentView.snp.makeConstraints {

            if
                #available(iOS 11.0, *)
            {
                // TODO: How to react on changing status bar height?
                $0.top
                    .equalTo(self.safeAreaLayoutGuide.snp.top)
                    .offset((type(of: self).isScreenWithNotch ? -10 : 0))
                $0.leading.trailing.bottom
                    .equalToSuperview()
            }
            else
            {
                // TODO: How to react on changing status bar height?
                $0.top
                    .equalToSuperview()
                    .offset(UIApplication.shared.statusBarFrame.height)
                $0.leading.trailing.bottom
                    .equalToSuperview()
            }
        }

        //--- other settings

        backgroundColor = .black

        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = type(of: self).appAreaCornerRadius
    }

    public
    required
    init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    //---

    func embed(_ nestedView: UIView)
    {
        contentView.addSubview(nestedView)

        //---

        nestedView.snp.makeConstraints {

            $0.edges.equalToSuperview()
        }
    }
}

//---

public
final
class NoNotchViewController: UIViewController
{
    public
    var statusbarStyle = UIStatusBarStyle.lightContent

    public
    var customView: NoNotchView!
    {
        return view as! NoNotchView //swiftlint:disable:this force_cast
    }

    //---

    public
    required
    init(with nestedVC: UIViewController)
    {
        super.init(nibName: nil, bundle: nil)

        //---

        addChildViewController(nestedVC)
    }

    public
    required
    init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    //---

    public
    override
    func loadView()
    {
        view = NoNotchView()
    }

    public
    override
    func viewDidLoad()
    {
        super.viewDidLoad()

        //---

        if
            let nestedView = childViewControllers.first?.view
        {
            customView.embed(nestedView)
        }
    }

    public
    override
    var childViewControllerForStatusBarHidden: UIViewController?
    {
        return childViewControllers.first
    }
    
    public
    override
    var preferredStatusBarStyle: UIStatusBarStyle
    {
        return statusbarStyle
    }
}
