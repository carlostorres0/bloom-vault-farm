import { Button } from "@/components/ui/button";
import { Menu } from "lucide-react";
import { Link, useLocation } from "react-router-dom";
import { WalletButton } from "@/components/WalletButton";
import farmLogo from "@/assets/farm-logo.png";

const FarmHeader = () => {
  const location = useLocation();
  
  const navItems = [
    { name: "Home", path: "/" },
    { name: "Dashboard", path: "/dashboard" },
    { name: "Yield Predictions", path: "/yield-predictions" },
    { name: "Finance", path: "/finance" },
    { name: "Analytics", path: "/analytics" }
  ];

  return (
    <header className="border-b border-border bg-card/50 backdrop-blur-sm">
      <div className="container mx-auto px-4">
        <div className="flex h-16 items-center justify-between">
          <Link to="/" className="flex items-center gap-3">
            <img src={farmLogo} alt="Agricultural Finance" className="h-10 w-10" />
            <div>
              <h1 className="text-xl font-bold text-foreground">Bloom Vault Farm</h1>
              <p className="text-sm text-muted-foreground">Decentralized Agricultural Finance Platform</p>
            </div>
          </Link>
          
          <nav className="hidden md:flex items-center gap-6">
            {navItems.map((item) => (
              <Link
                key={item.path}
                to={item.path}
                className={`transition-colors ${
                  location.pathname === item.path
                    ? "text-primary font-medium"
                    : "text-foreground hover:text-primary"
                }`}
              >
                {item.name}
              </Link>
            ))}
          </nav>

          <div className="flex items-center gap-3">
            <div className="hidden sm:flex">
              <WalletButton />
            </div>
            <Button variant="ghost" size="sm" className="md:hidden">
              <Menu className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </div>
    </header>
  );
};

export default FarmHeader;