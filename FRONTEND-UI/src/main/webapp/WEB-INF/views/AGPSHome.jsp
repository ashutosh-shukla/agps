<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AGPS Bank - Internet Banking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1e3a8a;
            --secondary-color: #1e40af;
            --accent-color: #0ea5e9;
            --success-color: #059669;
            --warning-color: #d97706;
            --text-dark: #1f2937;
            --text-light: #6b7280;
            --bg-light: #f8fafc;
            --border-color: #e5e7eb;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Header Styles */
        .top-bar {
            background-color: var(--bg-light);
            padding: 8px 0;
            font-size: 0.875rem;
            border-bottom: 1px solid var(--border-color);
        }

        .main-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 15px 0;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .bank-logo {
            font-size: 1.8rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }

        .nav-menu {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
            gap: 25px;
            align-items: center;
        }

        .nav-menu li a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: opacity 0.3s ease;
        }

        .nav-menu li a:hover {
            opacity: 0.8;
        }

        .language-selector {
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.875rem;
        }

        /* Header Buttons */
        .header-buttons {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .digital-account-btn {
            background: var(--accent-color);
            border: 2px solid var(--accent-color);
            color: white;
            padding: 8px 14px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.8rem;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .digital-account-btn:hover {
            background: transparent;
            color: var(--accent-color);
            border-color: var(--accent-color);
        }

        .login-btn {
            background: rgba(255,255,255,0.2);
            border: 2px solid rgba(255,255,255,0.5);
            color: white;
            padding: 8px 16px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.8rem;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .login-btn:hover {
            background: white;
            color: var(--primary-color);
        }

        .admin-btn {
            background: var(--warning-color);
            border: 2px solid var(--warning-color);
            color: white;
            padding: 8px 16px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.8rem;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .admin-btn:hover {
            background: transparent;
            color: var(--warning-color);
            border-color: var(--warning-color);
        }

        /* Secondary Navigation */
        .secondary-nav {
            background: white;
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .secondary-nav .nav-link {
            color: var(--text-dark);
            font-weight: 500;
            padding: 10px 20px;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .secondary-nav .nav-link:hover {
            background: linear-gradient(135deg, var(--accent-color) 0%, var(--primary-color) 100%);
            color: white;
        }

        /* Search Section */
        .search-section {
            background: var(--bg-light);
            padding: 30px 0;
        }

        .search-container {
            max-width: 600px;
            margin: 0 auto;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 15px 50px 15px 20px;
            border: 2px solid var(--border-color);
            border-radius: 50px;
            font-size: 1.1rem;
            outline: none;
            transition: border-color 0.3s ease;
        }

        .search-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(30, 58, 138, 0.1);
        }

        .search-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: var(--primary-color);
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .search-btn:hover {
            background: var(--secondary-color);
        }

        .voice-search {
            position: absolute;
            right: 50px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--primary-color);
            font-size: 1.2rem;
            cursor: pointer;
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(rgba(30, 58, 138, 0.9), rgba(30, 64, 175, 0.9)), url('/placeholder.svg?height=600&width=1200') center/cover;
            color: white;
            padding: 80px 0;
            position: relative;
        }

        .hero-content {
            max-width: 500px;
        }

        .hero-title {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .hero-description {
            font-size: 1.2rem;
            margin-bottom: 40px;
            line-height: 1.6;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .btn-primary-custom {
            background: white;
            color: var(--primary-color);
            border: 2px solid white;
            padding: 12px 25px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            background: transparent;
            color: white;
        }

        .btn-secondary-custom {
            background: transparent;
            color: white;
            border: 2px solid white;
            padding: 12px 25px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-secondary-custom:hover {
            background: white;
            color: var(--primary-color);
        }

        .btn-admin-custom {
            background: var(--warning-color);
            color: white;
            border: 2px solid var(--warning-color);
            padding: 12px 25px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-admin-custom:hover {
            background: transparent;
            color: var(--warning-color);
            border-color: var(--warning-color);
        }

        /* Features Section */
        .features-section {
            padding: 60px 0;
            background: white;
        }

        .feature-card {
            text-align: center;
            padding: 30px 20px;
            border-radius: 15px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            border: 1px solid var(--border-color);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(30, 58, 138, 0.1);
            border-color: var(--accent-color);
        }

        .feature-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .feature-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--text-dark);
        }

        .feature-description {
            color: var(--text-light);
            line-height: 1.6;
        }

        /* Quick Actions */
        .quick-actions {
            background: var(--bg-light);
            padding: 60px 0;
        }

        .quick-actions-container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .quick-action-card {
            background: white;
            border-radius: 15px;
            padding: 30px 20px;
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
            height: 100%;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .quick-action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(30, 58, 138, 0.15);
            border-color: var(--primary-color);
        }

        .quick-action-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .quick-action-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--text-dark);
        }

        .quick-action-btn {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .quick-action-btn:hover {
            transform: scale(1.05);
            color: white;
            box-shadow: 0 4px 15px rgba(30, 58, 138, 0.3);
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .nav-menu {
                flex-direction: column;
                gap: 15px;
            }
            
            .header-buttons {
                margin-top: 15px;
                justify-content: center;
            }
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2rem;
            }

            .action-buttons {
                flex-direction: column;
            }

            .search-container {
                margin: 0 20px;
            }

            .header-buttons {
                flex-direction: column;
                gap: 8px;
                width: 100%;
            }

            .digital-account-btn,
            .login-btn,
            .admin-btn {
                text-align: center;
                width: 100%;
                max-width: 200px;
            }
        }

        /* Additional Banking Theme Elements */
        .section-title {
            color: var(--text-dark);
            font-weight: 700;
        }

        .text-primary-custom {
            color: var(--primary-color) !important;
        }

        .bg-primary-custom {
            background-color: var(--primary-color) !important;
        }

        .border-primary-custom {
            border-color: var(--primary-color) !important;
        }
    </style>
</head>
<body>
    <!-- Top Bar -->
    <div class="top-bar">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <small class="text-muted">
                        <i class="fas fa-shield-alt me-2"></i>
                        AGPS Bank – Your Trust, Our Commitment.
                    </small>
                </div>
                <div class="col-md-6 text-end">
                    <!-- Additional top bar content can go here -->
                </div>
            </div>
        </div>
    </div>

    <!-- Main Header -->
    <header class="main-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-3 col-md-12 mb-3 mb-lg-0">
                    <a href="${pageContext.request.contextPath}/" class="bank-logo">
                        <i class="fas fa-university me-2"></i>AGPS BANK
                    </a>
                </div>
                <div class="col-lg-5 col-md-12 mb-3 mb-lg-0">
                    <ul class="nav-menu justify-content-center">
                        <li><a href="${pageContext.request.contextPath}/services">Our Services</a></li>
                        <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/support">Customer Support</a></li>
                        <li>
                            <select class="language-selector">
                                <option>English</option>
                                <option>हिंदी</option>
                            </select>
                        </li>
                    </ul>
                </div>
                <div class="col-lg-4 col-md-12">
                    <div class="header-buttons justify-content-center justify-content-lg-end">
                        <a href="${pageContext.request.contextPath}/account/open" class="digital-account-btn">
                            <i class="fas fa-plus-circle me-1"></i>Open Account
                        </a>
                        <a href="${pageContext.request.contextPath}/login" class="login-btn">
                            <i class="fas fa-sign-in-alt me-1"></i>LOGIN
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/login" class="admin-btn">
                            <i class="fas fa-user-shield me-1"></i>ADMIN
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Secondary Navigation -->
    <nav class="secondary-nav">
        <div class="container">
            <ul class="nav justify-content-center">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/products">
                        <i class="fas fa-search me-2"></i>Explore Services
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/deals">
                        <i class="fas fa-gift me-2"></i>Grab Deals
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/payments">
                        <i class="fas fa-credit-card me-2"></i>Make Payments
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/bank-smart">
                        <i class="fas fa-mobile-alt me-2"></i>Smart Banking
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/netbanking">
                        <i class="fas fa-laptop me-2"></i>Net Banking
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- Search Section -->
    <section class="search-section">
        <div class="container">
            <div class="search-container">
                <form action="${pageContext.request.contextPath}/search" method="get">
                    <input type="text" class="search-input" name="query" placeholder="Search for Products, Services..." required>
                    <button type="button" class="voice-search" title="Voice Search">
                        <i class="fas fa-microphone"></i>
                    </button>
                    <button type="submit" class="search-btn" title="Search">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>
        </div>
    </section>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <div class="hero-content">
                        <h1 class="hero-title">Internet Banking</h1>
                        <p class="hero-description">
                            Bank online, securely and conveniently, from the comfort of your home or office
                        </p>
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/login" class="btn-primary-custom">
                                <i class="fas fa-sign-in-alt me-2"></i>Login
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn-secondary-custom">
                                <i class="fas fa-user-plus me-2"></i>Create Account
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/login" class="btn-admin-custom">
                                <i class="fas fa-user-shield me-2"></i>Admin Login
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="text-center text-white">
                        <div class="row">
                            <div class="col-6 mb-4">
                                <div class="feature-highlight">
                                    <i class="fas fa-shield-alt fa-3x mb-3"></i>
                                    <h5>Security</h5>
                                </div>
                            </div>
                            <div class="col-6 mb-4">
                                <div class="feature-highlight">
                                    <i class="fas fa-clock fa-3x mb-3"></i>
                                    <h5>24x7 Access</h5>
                                </div>
                            </div>
                            <div class="col-6 mb-4">
                                <div class="feature-highlight">
                                    <i class="fas fa-language fa-3x mb-3"></i>
                                    <h5>Multi-language log-in</h5>
                                </div>
                            </div>
                            <div class="col-6 mb-4">
                                <div class="feature-highlight">
                                    <i class="fas fa-cogs fa-3x mb-3"></i>
                                    <h5>10+ services</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section">
        <div class="container">
            <div class="row text-center mb-5">
                <div class="col-12">
                    <h2 class="mb-3 section-title">Internet Banking - Getting Started</h2>
                    <p class="lead text-muted">Experience seamless banking with our comprehensive digital platform</p>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fab fa-whatsapp"></i>
                        </div>
                        <h4 class="feature-title">WhatsApp Banking</h4>
                        <p class="feature-description">Access your account details anytime, anywhere with our secure WhatsApp feature</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-exchange-alt"></i>
                        </div>
                        <h4 class="feature-title">Fund Transfer</h4>
                        <p class="feature-description">Transfer funds instantly to any bank account across India with IMPS, NEFT & RTGS</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-piggy-bank"></i>
                        </div>
                        <h4 class="feature-title">Deposit & Withdraw</h4>
                        <p class="feature-description">Deposit money, withdraw money with few clicks</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Quick Actions -->
    <section class="quick-actions">
        <div class="container">
            <div class="row text-center mb-5">
                <div class="col-12">
                    <h2 class="mb-3 section-title">Quick Actions</h2>
                    <p class="lead text-muted">Get started with these essential banking services</p>
                </div>
            </div>
            <div class="quick-actions-container">
                <div class="row justify-content-center">
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="quick-action-card">
                            <div class="quick-action-icon">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <h5 class="quick-action-title">Create Account</h5>
                            <p class="text-muted mb-3">Join AGPS Bank family today</p>
                            <a href="${pageContext.request.contextPath}/register" class="quick-action-btn">Sign Up Now</a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="quick-action-card">
                            <div class="quick-action-icon">
                                <i class="fas fa-laptop"></i>
                            </div>
                            <h5 class="quick-action-title">Internet Banking</h5>
                            <p class="text-muted mb-3">Perform your first transaction</p>
                            <a href="${pageContext.request.contextPath}/kyc/upload" class="quick-action-btn">Click Now</a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="quick-action-card">
                            <div class="quick-action-icon">
                                <i class="fas fa-headset"></i>
                            </div>
                            <h5 class="quick-action-title">Customer Support</h5>
                            <p class="text-muted mb-3">Get help when you need it</p>
                            <a href="${pageContext.request.contextPath}/support/contact" class="quick-action-btn">Contact Us</a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="quick-action-card">
                            <div class="quick-action-icon">
                                <i class="fas fa-user-shield"></i>
                            </div>
                            <h5 class="quick-action-title">Admin Panel</h5>
                            <p class="text-muted mb-3">Administrative access</p>
                            <a href="${pageContext.request.contextPath}/admin/login" class="quick-action-btn">Admin Login</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <p class="mb-0">&copy; 2025 AGPS Bank. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-end">
                    <a href="${pageContext.request.contextPath}/privacy" class="text-white text-decoration-none me-3">Privacy Policy</a>
                    <a href="${pageContext.request.contextPath}/terms" class="text-white text-decoration-none">Terms & Conditions</a>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Voice search functionality
        document.querySelector('.voice-search').addEventListener('click', function() {
            if ('webkitSpeechRecognition' in window) {
                const recognition = new webkitSpeechRecognition();
                recognition.continuous = false;
                recognition.interimResults = false;
                recognition.lang = 'en-US';

                recognition.start();

                recognition.onresult = function(event) {
                    const transcript = event.results[0][0].transcript;
                    document.querySelector('.search-input').value = transcript;
                };

                recognition.onerror = function(event) {
                    console.log('Speech recognition error:', event.error);
                };
            } else {
                alert('Speech recognition not supported in this browser.');
            }
        });

        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            });
        });

        // Add loading animation to buttons
        document.querySelectorAll('.quick-action-btn, .btn-primary-custom, .btn-secondary-custom, .btn-admin-custom').forEach(button => {
            button.addEventListener('click', function(e) {
                if (this.getAttribute('href') !== '#') {
                    const originalText = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Loading...';
                    
                    setTimeout(() => {
                        this.innerHTML = originalText;
                    }, 2000);
                }
            });
        });
    </script>
</body>
</html>