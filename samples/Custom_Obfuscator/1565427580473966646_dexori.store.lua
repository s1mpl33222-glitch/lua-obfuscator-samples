<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Dexori</title>
<meta name="description" content="">
<meta property="og:title" content="Dexori">
<meta property="og:description" content="">
<meta property="og:image" content="https://dexori.store/storage/images/1222307.webp">
<meta name="twitter:title" content="Dexori">
<meta name="twitter:description" content="">
<meta name="twitter:card" content="summary">
<link rel="icon" type="image/png" href="">
<meta name="theme-color" content="#bc1c2a" />


<script type="application/ld+json">
[{"@context":"https://schema.org","@type":"OnlineStore","@id":"https://dexori.store/#organization","name":"Dexori","url":"https://dexori.store","logo":"https://dexori.store/storage/images/1222307.webp"},{"@context":"https://schema.org","@type":"WebSite","@id":"https://dexori.store/#website","name":"Dexori","url":"https://dexori.store","publisher":{"@id":"https://dexori.store/#organization"}}]
</script>


    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
      crossorigin="anonymous"
    />
    <link href="https://dexori.store/assets/274589/pro.css?v=1787771909101" rel="stylesheet"/>
    <link href="https://dexori.store/assets/274589/theme.css?v=1787771910129" rel="stylesheet"/>
    <link href="https://dexori.store/assets/274589/custom.css?v=1787771908565" rel="stylesheet"/>

    <style id="theme-styles">
      :root {
        --cl-accent: #bc1c2a;
        --cl-accent-rgb: 188,28,42;
        --cl-background-primary: #060606;
        --cl-background-primary-rgb: 6,6,6;
        --cl-background-secondary: #0d0d0d;
        --cl-background-secondary-rgb: 13,13,13;
        --cl-border: #ffffff12;
        --cl-border-rgb: 255,255,255,0.07;
        --bs-font-sans-serif: 'Inter', sans-serif;
        --dx-font-heading: 'Chakra Petch', sans-serif;
        --cl-snow: 255,255,255;
      }
    </style>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Chakra+Petch:wght@500;600;700&display=swap" rel="stylesheet" id="theme-font">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/choices.js@10.2.0/public/assets/styles/choices.min.css" rel="stylesheet" integrity="sha256-gS3HxgWFFFqEo0wQoALebu5XlWdYr3gqd4/Tk5wt8Ig=" crossorigin="anonymous" />
  </head>
  <body>
    

    <div class="flex-wrapper" id="app" x-data="app">
      <div>
        
          <header class="sticky-top">
            <div class="announcement component" style="display: none;" data-component-id="announcement">
  
  
</div>
            <nav class="dx-navbar navbar navbar-expand-lg component" data-component-id="navbar">
  <div class="container py-2">
    
    <a class="navbar-brand" href="https://dexori.store/">
      
        <img src="https://dexori.store/storage/images/1222307.webp" alt="Dexori" />
      
      
        <span>Dexori</span>
      
    </a>
    

    <div class="d-flex gap-2 align-items-center dx-nav-mobile-actions">
      
      <div class="cart d-lg-none">
        <a class="dx-nav-icon-btn" href="https://dexori.store/cart" aria-label="Cart">
          <svg xmlns="http://www.w3.org/2000/svg" class="icon" viewBox="0 0 24 24"><path fill="currentColor" d="M7 22q-.825 0-1.412-.587T5 20t.588-1.412T7 18t1.413.588T9 20t-.587 1.413T7 22m10 0q-.825 0-1.412-.587T15 20t.588-1.412T17 18t1.413.588T19 20t-.587 1.413T17 22M6.15 6l2.4 5h7l2.75-5zM5.2 4h14.75q.575 0 .875.513t.025 1.037l-3.55 6.4q-.275.5-.737.775T15.55 13H8.1L7 15h11q.425 0 .713.288T19 16t-.288.713T18 17H7q-1.125 0-1.7-.987t-.05-1.963L6.6 11.6L3 4H2q-.425 0-.712-.288T1 3t.288-.712T2 2h1.625q.275 0 .525.15t.375.425zm3.35 7h7z"/></svg>
          <template x-if="appCart.countWithQuantities > 0">
            <span class="count">
              <span x-text="appCart.countWithQuantities > 9 ? '9+' : appCart.countWithQuantities"></span>
            </span>
          </template>
        </a>
      </div>
      

      <button
        class="navbar-toggler"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span class="navbar-toggler-icon"></span>
      </button>
    </div>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        
        <li class="nav-item">
          <a class="nav-link" href="https://dexori.store/" target="">
            Home
          </a>
        </li>
        
        <li class="nav-item">
          <a class="nav-link" href="https://dexori.store/#products" target="">
            Products
          </a>
        </li>
        
        <li class="nav-item">
          <a class="nav-link" href="https://dexori.store/feedback" target="">
            Reviews
          </a>
        </li>
        
        <li class="nav-item">
          <a class="nav-link" href="https://dexori.store/faq" target="">
            FAQ
          </a>
        </li>
        
        <li class="nav-item">
          <a class="nav-link" href="https://dexori.store/status" target="">
            Status
          </a>
        </li>
        
      </ul>

      <ul class="navbar-nav gap-2 align-items-lg-center">
        

        
        <li class="nav-item dx-nav-currency">
          <div class="currency-selector">
            <select>
              
                <option value="usd">USD</option>
              
                <option value="aed">AED</option>
              
                <option value="afn">AFN</option>
              
                <option value="all">ALL</option>
              
                <option value="amd">AMD</option>
              
                <option value="ang">ANG</option>
              
                <option value="aoa">AOA</option>
              
                <option value="ars">ARS</option>
              
                <option value="aud">AUD</option>
              
                <option value="awg">AWG</option>
              
                <option value="azn">AZN</option>
              
                <option value="bam">BAM</option>
              
                <option value="bbd">BBD</option>
              
                <option value="bdt">BDT</option>
              
                <option value="bgn">BGN</option>
              
                <option value="bhd">BHD</option>
              
                <option value="bif">BIF</option>
              
                <option value="bmd">BMD</option>
              
                <option value="bnd">BND</option>
              
                <option value="bob">BOB</option>
              
                <option value="brl">BRL</option>
              
                <option value="bsd">BSD</option>
              
                <option value="btc">BTC</option>
              
                <option value="btn">BTN</option>
              
                <option value="bwp">BWP</option>
              
                <option value="byn">BYN</option>
              
                <option value="bzd">BZD</option>
              
                <option value="cad">CAD</option>
              
                <option value="cdf">CDF</option>
              
                <option value="chf">CHF</option>
              
                <option value="clf">CLF</option>
              
                <option value="clp">CLP</option>
              
                <option value="cnh">CNH</option>
              
                <option value="cny">CNY</option>
              
                <option value="cop">COP</option>
              
                <option value="crc">CRC</option>
              
                <option value="cuc">CUC</option>
              
                <option value="cup">CUP</option>
              
                <option value="cve">CVE</option>
              
                <option value="czk">CZK</option>
              
                <option value="djf">DJF</option>
              
                <option value="dkk">DKK</option>
              
                <option value="dop">DOP</option>
              
                <option value="dzd">DZD</option>
              
                <option value="egp">EGP</option>
              
                <option value="ern">ERN</option>
              
                <option value="etb">ETB</option>
              
                <option value="eur">EUR</option>
              
                <option value="fjd">FJD</option>
              
                <option value="fkp">FKP</option>
              
                <option value="gbp">GBP</option>
              
                <option value="gel">GEL</option>
              
                <option value="ggp">GGP</option>
              
                <option value="ghs">GHS</option>
              
                <option value="gip">GIP</option>
              
                <option value="gmd">GMD</option>
              
                <option value="gnf">GNF</option>
              
                <option value="gtq">GTQ</option>
              
                <option value="gyd">GYD</option>
              
                <option value="hkd">HKD</option>
              
                <option value="hnl">HNL</option>
              
                <option value="hrk">HRK</option>
              
                <option value="htg">HTG</option>
              
                <option value="huf">HUF</option>
              
                <option value="idr">IDR</option>
              
                <option value="ils">ILS</option>
              
                <option value="imp">IMP</option>
              
                <option value="inr">INR</option>
              
                <option value="iqd">IQD</option>
              
                <option value="irr">IRR</option>
              
                <option value="isk">ISK</option>
              
                <option value="jep">JEP</option>
              
                <option value="jmd">JMD</option>
              
                <option value="jod">JOD</option>
              
                <option value="jpy">JPY</option>
              
                <option value="kes">KES</option>
              
                <option value="kgs">KGS</option>
              
                <option value="khr">KHR</option>
              
                <option value="kmf">KMF</option>
              
                <option value="kpw">KPW</option>
              
                <option value="krw">KRW</option>
              
                <option value="kwd">KWD</option>
              
                <option value="kyd">KYD</option>
              
                <option value="kzt">KZT</option>
              
                <option value="lak">LAK</option>
              
                <option value="lbp">LBP</option>
              
                <option value="lkr">LKR</option>
              
                <option value="lrd">LRD</option>
              
                <option value="lsl">LSL</option>
              
                <option value="lyd">LYD</option>
              
                <option value="mad">MAD</option>
              
                <option value="mdl">MDL</option>
              
                <option value="mga">MGA</option>
              
                <option value="mkd">MKD</option>
              
                <option value="mmk">MMK</option>
              
                <option value="mnt">MNT</option>
              
                <option value="mop">MOP</option>
              
                <option value="mru">MRU</option>
              
                <option value="mur">MUR</option>
              
                <option value="mvr">MVR</option>
              
                <option value="mwk">MWK</option>
              
                <option value="mxn">MXN</option>
              
                <option value="myr">MYR</option>
              
                <option value="mzn">MZN</option>
              
                <option value="nad">NAD</option>
              
                <option value="ngn">NGN</option>
              
                <option value="nio">NIO</option>
              
                <option value="nok">NOK</option>
              
                <option value="npr">NPR</option>
              
                <option value="nzd">NZD</option>
              
                <option value="omr">OMR</option>
              
                <option value="pab">PAB</option>
              
                <option value="pen">PEN</option>
              
                <option value="pgk">PGK</option>
              
                <option value="php">PHP</option>
              
                <option value="pkr">PKR</option>
              
                <option value="pln">PLN</option>
              
                <option value="pyg">PYG</option>
              
                <option value="qar">QAR</option>
              
                <option value="ron">RON</option>
              
                <option value="rsd">RSD</option>
              
                <option value="rub">RUB</option>
              
                <option value="rwf">RWF</option>
              
                <option value="sar">SAR</option>
              
                <option value="sbd">SBD</option>
              
                <option value="scr">SCR</option>
              
                <option value="sdg">SDG</option>
              
                <option value="sek">SEK</option>
              
                <option value="sgd">SGD</option>
              
                <option value="shp">SHP</option>
              
                <option value="sle">SLE</option>
              
                <option value="sll">SLL</option>
              
                <option value="sos">SOS</option>
              
                <option value="srd">SRD</option>
              
                <option value="ssp">SSP</option>
              
                <option value="std">STD</option>
              
                <option value="stn">STN</option>
              
                <option value="svc">SVC</option>
              
                <option value="syp">SYP</option>
              
                <option value="szl">SZL</option>
              
                <option value="thb">THB</option>
              
                <option value="tjs">TJS</option>
              
                <option value="tmt">TMT</option>
              
                <option value="tnd">TND</option>
              
                <option value="top">TOP</option>
              
                <option value="try">TRY</option>
              
                <option value="ttd">TTD</option>
              
                <option value="twd">TWD</option>
              
                <option value="tzs">TZS</option>
              
                <option value="uah">UAH</option>
              
                <option value="ugx">UGX</option>
              
                <option value="uyu">UYU</option>
              
                <option value="uzs">UZS</option>
              
                <option value="ves">VES</option>
              
                <option value="vnd">VND</option>
              
                <option value="vuv">VUV</option>
              
                <option value="wst">WST</option>
              
                <option value="xaf">XAF</option>
              
                <option value="xag">XAG</option>
              
                <option value="xau">XAU</option>
              
                <option value="xcd">XCD</option>
              
                <option value="xcg">XCG</option>
              
                <option value="xdr">XDR</option>
              
                <option value="xof">XOF</option>
              
                <option value="xpd">XPD</option>
              
                <option value="xpf">XPF</option>
              
                <option value="xpt">XPT</option>
              
                <option value="yer">YER</option>
              
                <option value="zar">ZAR</option>
              
                <option value="zmw">ZMW</option>
              
                <option value="zwg">ZWG</option>
              
                <option value="zwl">ZWL</option>
              
                <option value="ltc">LTC</option>
              
                <option value="eth">ETH</option>
              
                <option value="sol">SOL</option>
              
            </select>
          </div>
        </li>
        

        
        <li class="nav-item user">
          
            <button type="button" data-bs-toggle="modal" data-bs-target="#customer-login-modal" class="dx-nav-ghost">
              <i class="fa-regular fa-user"></i>
              <span>Login</span>
            </button>
          
        </li>
        

        
        <li class="nav-item cart d-none d-lg-block">
          <a class="dx-nav-icon-btn" href="https://dexori.store/cart" aria-label="Cart">
            <svg xmlns="http://www.w3.org/2000/svg" class="icon" viewBox="0 0 24 24"><path fill="currentColor" d="M7 22q-.825 0-1.412-.587T5 20t.588-1.412T7 18t1.413.588T9 20t-.587 1.413T7 22m10 0q-.825 0-1.412-.587T15 20t.588-1.412T17 18t1.413.588T19 20t-.587 1.413T17 22M6.15 6l2.4 5h7l2.75-5zM5.2 4h14.75q.575 0 .875.513t.025 1.037l-3.55 6.4q-.275.5-.737.775T15.55 13H8.1L7 15h11q.425 0 .713.288T19 16t-.288.713T18 17H7q-1.125 0-1.7-.987t-.05-1.963L6.6 11.6L3 4H2q-.425 0-.712-.288T1 3t.288-.712T2 2h1.625q.275 0 .525.15t.375.425zm3.35 7h7z"/></svg>
            <template x-if="appCart.countWithQuantities > 0">
              <span class="count">
                <span x-text="appCart.countWithQuantities > 9 ? '9+' : appCart.countWithQuantities"></span>
              </span>
            </template>
          </a>
        </li>
        
      </ul>
    </div>
  </div>
</nav>

<script>
  (function () {
    const nav = document.querySelector('.dx-navbar[data-component-id="navbar"]');
    if (!nav) return;

    const here = location.pathname.replace(/\/+$/, '').toLowerCase();
    nav.querySelectorAll('.nav-link').forEach((a) => {
      const href = (a.getAttribute('href') || '')
        .replace(/^https?:\/\/[^/]+/, '')
        .replace(/\/+$/, '')
        .toLowerCase();
      if (href && href === here) a.classList.add('active');
    });

    const setShadow = () => nav.classList.toggle('is-scrolled', window.scrollY > 4);
    setShadow();
    window.addEventListener('scroll', setShadow, { passive: true });
  })();
</script>
          </header>
        

        <div class="components">
  
    


<section
  id="hero"
  class="hero dx-hero height-tall dx-hero--tall dx-hero--align-center component"
  data-component-id="hero"
  
>
  <div class="dx-hero-glow" aria-hidden="true"></div>
  <div class="dx-hero-grid" aria-hidden="true"></div>

  <div class="container">
    <div class="row align-items-center g-5">
      <div class="col-12">
        <div class="content dx-hero-content">
          
            <div class="dx-hero-badge">
              <span class="dx-hero-badge-dot" aria-hidden="true"></span>
              Instant Delivery &bull; 24/7 Support
            </div>
          

          <h1 class="dx-hero-title">Dexori</h1>

          
            <p class="dx-hero-subtitle">Best Scripts</p>
          

          <div class="dx-hero-ctas">
            
              <a href="https://dexori.store/#products" class="btn btn-primary dx-btn-main">
                Browse Products
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
              </a>
            
            
              <a href="https://dexori.store/faq" class="btn dx-btn-ghost">
                How It Works
              </a>
            
          </div>

          
            <div class="dx-hero-search">
              <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
              <input
                type="text"
                id="dx-hero-search-input"
                placeholder="Search products..."
                autocomplete="off"
              />
            </div>
          

          
        </div>
      </div>

      
    </div>
  </div>
</section>


<script>
  (function () {
    const input = document.getElementById('dx-hero-search-input');
    if (!input) return;

    const filterCards = () => {
      const q = input.value.trim().toLowerCase();
      document.querySelectorAll('.products .card').forEach((card) => {
        const title = (card.querySelector('.card-title')?.textContent || '').toLowerCase();
        const col = card.closest('[class*="col-"]') || card;
        col.style.display = !q || title.includes(q) ? '' : 'none';
      });
    };

    input.addEventListener('input', filterCards);
    input.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        document.getElementById('products')?.scrollIntoView({ behavior: 'smooth' });
      }
    });
  })();
</script>

  
    <section id="stats" class="dx-stats component" data-component-id="stats">
  <div class="container">
    
    

    <div class="row g-4">
      

      

      

      
    </div>
  </div>
</section>
  
    <section class="container py-20 component" id="products" data-component-id="products">
  
  <div class="section-title">
    <h2>Products</h2>
  </div>
  
  
  <div class="section-subtitle">
    <p>Pick your product — delivered automatically, around the clock.</p>
  </div>
  
  <div>
    <div class="row products">
      
        
          
            <div class="col-12 col-md-6 col-lg-4 col-xl-3 mb-4">
  <a
    class="card dx-card text-decoration-none"
    href="https://dexori.store/product/lifetime-key"
    data-bs-toggle=""
    data-bs-target=""
  >
    <div class="card-img-top">
      
        <img src="https://dexori.store/storage/images/1222307.webp" class="img-fluid" loading="lazy" alt="Lifetime Key" />
      

      <div class="overlay">
        <button class="btn btn-primary btn-sm dx-card-cta" type="button">
          View Details
        </button>
      </div>

      
    </div>

    <div class="card-body">
      <div class="info">
        <p class="price">
          
            <span x-text="appCurrency.format(20.00, 'USD')">
              $20.00
            </span>
          

          
            <s class="dx-price-old" x-text="appCurrency.format(25.00, 'USD')">
              $25.00
            </s>
          
        </p>

        <span class="dx-chip
           dx-chip-ok">
          
            295 In Stock
          
        </span>
      </div>

      <h5 class="card-title">Lifetime Key</h5>
    </div>
  </a>
</div>
          
        
      
    </div>
  </div>
</section>


  

  
    <section class="container py-20 features component" data-component-id="features">
  
  <div class="section-title">
    <h2>Why Dexori</h2>
  </div>
  
  
  <div class="row list">
    
      
    

    
    <div class="col-12 col-md-4">
      <div class="feature">
        <i class="fas fa-bolt"></i>
        <h4 class="title">
          Instant Delivery
        </h4>
        <p class="description">
          <span class="whitespace-pre-line">Your order is delivered automatically within seconds of payment — no waiting, no manual processing.</span>
        </p>
      </div>
    </div>
    
    <div class="col-12 col-md-4">
      <div class="feature">
        <i class="fas fa-shield-halved"></i>
        <h4 class="title">
          Secure Checkout
        </h4>
        <p class="description">
          <span class="whitespace-pre-line">Pay safely with cards. Every transaction is encrypted end to end.</span>
        </p>
      </div>
    </div>
    
    <div class="col-12 col-md-4">
      <div class="feature">
        <i class="fas fa-headset"></i>
        <h4 class="title">
          24/7 Support
        </h4>
        <p class="description">
          <span class="whitespace-pre-line">Questions or issues? Our support team is available around the clock to get you sorted fast.</span>
        </p>
      </div>
    </div>
    
  </div>
</section>
  
    <section class="py-20 faq bg-block-primary component" data-component-id="faq">
  <div class="container">
    
    <div class="section-title">
      <h2>FAQ</h2>
    </div>
    
    
    <div class="section-subtitle">
      <p>Answers to the questions we get the most.</p>
    </div>
    
    <div class="accordion">
      
      
      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-faq-1" aria-expanded="false" aria-controls="collapse-faq-1">
            How fast will I receive my order?
          </button>
        </h2>
        <div id="collapse-faq-1" class="accordion-collapse collapse" data-bs-parent="#collapse-faq-1">
          <div class="accordion-body">
            <span class="whitespace-pre-line">Delivery is fully automated. As soon as your payment is confirmed, your product is delivered instantly — usually within seconds.</span>
          </div>
        </div>
      </div>
      
      
      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-faq-2" aria-expanded="false" aria-controls="collapse-faq-2">
            What payment methods do you accept?
          </button>
        </h2>
        <div id="collapse-faq-2" class="accordion-collapse collapse" data-bs-parent="#collapse-faq-2">
          <div class="accordion-body">
            <span class="whitespace-pre-line">We accept all payment methods shown at checkout, including cards and cryptocurrency. Available options may vary by product.</span>
          </div>
        </div>
      </div>
      
      
      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-faq-3" aria-expanded="false" aria-controls="collapse-faq-3">
            What if something is wrong with my order?
          </button>
        </h2>
        <div id="collapse-faq-3" class="accordion-collapse collapse" data-bs-parent="#collapse-faq-3">
          <div class="accordion-body">
            <span class="whitespace-pre-line">Open a ticket from your customer dashboard or reach out through our support channels and we'll make it right as quickly as possible.</span>
          </div>
        </div>
      </div>
      
      
      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-faq-4" aria-expanded="false" aria-controls="collapse-faq-4">
            Do you offer refunds?
          </button>
        </h2>
        <div id="collapse-faq-4" class="accordion-collapse collapse" data-bs-parent="#collapse-faq-4">
          <div class="accordion-body">
            <span class="whitespace-pre-line">Please read our Refund Policy for full details. If your product arrives faulty and we can't replace it, you'll be taken care of.</span>
          </div>
        </div>
      </div>
      
      
      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-faq-5" aria-expanded="false" aria-controls="collapse-faq-5">
            Is my purchase secure?
          </button>
        </h2>
        <div id="collapse-faq-5" class="accordion-collapse collapse" data-bs-parent="#collapse-faq-5">
          <div class="accordion-body">
            <span class="whitespace-pre-line">Yes. Checkout is encrypted end to end and we never store your payment details on our servers.</span>
          </div>
        </div>
      </div>
      
    </div>
  </div>
</section>
  
</div>
      </div>

      
        <footer class="footer dx-footer component" data-component-id="footer">
  <div class="container">
    <div class="row py-5 gy-4">
      <div class="col-12 col-lg-5">
        <div class="dx-footer-brand">
          <a class="dx-footer-brand-row" href="https://dexori.store/">
            
              <img src="https://dexori.store/storage/images/1222307.webp" alt="Dexori" class="dx-footer-logo" />
            
            
              <span class="dx-footer-name">Dexori</span>
            
          </a>

          

          
            <div class="dx-footer-socials">
              
              
              
              
              
            </div>
          
        </div>
      </div>

      <div class="col-6 col-lg-3 offset-lg-1">
        
          <h5 class="dx-footer-col-title">Navigation</h5>
        
        <ul class="dx-footer-nav">
          
            <li><a href="https://dexori.store/">Home</a></li>
          
            <li><a href="https://dexori.store/#products">Products</a></li>
          
            <li><a href="https://dexori.store/feedback">Reviews</a></li>
          
            <li><a href="https://dexori.store/status">Status</a></li>
          
        </ul>
      </div>

      <div class="col-6 col-lg-3">
        
          <h5 class="dx-footer-col-title">Legal</h5>
        
        <ul class="dx-footer-nav">
          
            <li><a href="https://dexori.store/terms-of-service">Terms of Service</a></li>
          
            <li><a href="https://dexori.store/privacy-policy">Privacy Policy</a></li>
          
            <li><a href="https://dexori.store/refund-policy">Refund Policy</a></li>
          
        </ul>
      </div>
    </div>

    <div class="dx-footer-bottom">
      <p>&copy; 2026 Dexori. All rights reserved.</p>
      <p class="dx-footer-secure"><i class="fa-solid fa-lock" aria-hidden="true"></i> Secure checkout &middot; Instant delivery</p>
    </div>
  </div>
</footer>
        <div class="modal fade" id="customer-login-modal" tabindex="-1" aria-labelledby="customer-login-modal-label" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="customer-login-modal-label">
          Log in to Your Customer Account
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div x-show="appCustomer.modalStep === 1">
          <form @submit.prevent="appCustomer.modalRequestOtp()">
            <div class="mb-1">
              <label class="mb-0 form-label">
                E-mail Address
              </label>
              <small class="d-block form-text">
                We'll send you a one-time password to this email address.
              </small>
            </div>
            <div class="mt-2">
              <input 
                type="email"
                x-model="appCustomer.modalEmail"
                x-ref="appCustomer.modalEmailInput"
                placeholder="name@domain.com"
                class="form-control"
              />
            </div>

            
              <div
                x-cloak
                x-show="!appCustomer.altchaPayload"
                class="transition-opacity mt-2"
                x-transition:enter="transition ease-out duration-300 transform"
                x-transition:enter-start="opacity-0"
                x-transition:enter-end="opacity-100"
                x-transition:leave="transition ease-in duration-200 transform"
                x-transition:leave-start="opacity-100"
                x-transition:leave-end="opacity-0"
              >
                <altcha-widget
                  challengejson='{"algorithm":"SHA-256","challenge":"885b56d856be41601d2afa09e83f21fc286bd0a8af5f7b5d7a18864f5155fede","maxnumber":10000,"salt":"0654999903c310437ad9c42d?expires=1793298306","signature":"f4953437393de903484922e788e8a7db74fe2d6e1a295008fe50dc27cbad9c6d"}'
                  auto="onload"
                  hidefooter="true"
                  hidelogo="true"
                  x-ref="appCustomer.altcha"
                ></altcha-widget>
              </div>
            

            <p x-show="appCustomer.modalEmailError" class="form-text text-danger" x-text="appCustomer.modalEmailError"></p>
            <button 
              type="submit"
              class="btn btn-primary mt-3 w-100"
              :disabled="appCustomer.modalLoading"
            >
              <span>Continue</span>
              <template x-if="!appCustomer.modalLoading">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><!-- Icon from Material Symbols by Google - https://github.com/google/material-design-icons/blob/master/LICENSE --><path fill="currentColor" d="M16.15 13H5q-.425 0-.712-.288T4 12t.288-.712T5 11h11.15L13.3 8.15q-.3-.3-.288-.7t.288-.7q.3-.3.713-.312t.712.287L19.3 11.3q.15.15.213.325t.062.375t-.062.375t-.213.325l-4.575 4.575q-.3.3-.712.288t-.713-.313q-.275-.3-.288-.7t.288-.7z"/></svg>
              </template>
              <template x-if="appCustomer.modalLoading">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-dasharray="16" stroke-dashoffset="16" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3c4.97 0 9 4.03 9 9"><animate fill="freeze" attributeName="stroke-dashoffset" dur="0.2s" values="16;0"/><animateTransform attributeName="transform" dur="1.5s" repeatCount="indefinite" type="rotate" values="0 12 12;360 12 12"/></path></svg>
              </template>
            </button>
          </form>
        </div>

        <div x-show="appCustomer.modalStep === 2">
          <form @submit.prevent="appCustomer.modalLogin()">
            <div class="mb-1">
              <label class="mb-0 form-label">
                One Time Password
              </label>
              <small class="d-block form-text">
                A 6-digit code has been sent to <span x-text="appCustomer.modalEmail"></span>.
              </small>
            </div>
            <div class="d-flex gap-2 mt-2">
              
                <input 
                  type="text"
                  maxlength="1"
                  x-model="appCustomer.modalOtpDigits[0]"
                  x-ref="appCustomer.modalOtpInputs[0]"
                  @input="appCustomer.modalOtpHandleInput(0)"
                  @keydown="appCustomer.modalOtpHandleKeyDown(0, $event)"
                  class="form-control text-center"
                  style="width: 2.5rem; height: 3rem; font-size: 1.25rem;"
                />
              
                <input 
                  type="text"
                  maxlength="1"
                  x-model="appCustomer.modalOtpDigits[1]"
                  x-ref="appCustomer.modalOtpInputs[1]"
                  @input="appCustomer.modalOtpHandleInput(1)"
                  @keydown="appCustomer.modalOtpHandleKeyDown(1, $event)"
                  class="form-control text-center"
                  style="width: 2.5rem; height: 3rem; font-size: 1.25rem;"
                />
              
                <input 
                  type="text"
                  maxlength="1"
                  x-model="appCustomer.modalOtpDigits[2]"
                  x-ref="appCustomer.modalOtpInputs[2]"
                  @input="appCustomer.modalOtpHandleInput(2)"
                  @keydown="appCustomer.modalOtpHandleKeyDown(2, $event)"
                  class="form-control text-center"
                  style="width: 2.5rem; height: 3rem; font-size: 1.25rem;"
                />
              
                <input 
                  type="text"
                  maxlength="1"
                  x-model="appCustomer.modalOtpDigits[3]"
                  x-ref="appCustomer.modalOtpInputs[3]"
                  @input="appCustomer.modalOtpHandleInput(3)"
                  @keydown="appCustomer.modalOtpHandleKeyDown(3, $event)"
                  class="form-control text-center"
                  style="width: 2.5rem; height: 3rem; font-size: 1.25rem;"
                />
              
                <input 
                  type="text"
                  maxlength="1"
                  x-model="appCustomer.modalOtpDigits[4]"
                  x-ref="appCustomer.modalOtpInputs[4]"
                  @input="appCustomer.modalOtpHandleInput(4)"
                  @keydown="appCustomer.modalOtpHandleKeyDown(4, $event)"
                  class="form-control text-center"
                  style="width: 2.5rem; height: 3rem; font-size: 1.25rem;"
                />
              
                <input 
                  type="text"
                  maxlength="1"
                  x-model="appCustomer.modalOtpDigits[5]"
                  x-ref="appCustomer.modalOtpInputs[5]"
                  @input="appCustomer.modalOtpHandleInput(5)"
                  @keydown="appCustomer.modalOtpHandleKeyDown(5, $event)"
                  class="form-control text-center"
                  style="width: 2.5rem; height: 3rem; font-size: 1.25rem;"
                />
              
            </div>
            <p x-show="appCustomer.modalOtpError" class="form-text text-danger" x-text="appCustomer.modalOtpError"></p>
            <button 
              type="submit"
              class="btn btn-primary mt-3 w-100"
              :disabled="appCustomer.modalLoading"
            >
              <span>Log In</span>
              <template x-if="!appCustomer.modalLoading">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><!-- Icon from Material Symbols by Google - https://github.com/google/material-design-icons/blob/master/LICENSE --><path fill="currentColor" d="M16.15 13H5q-.425 0-.712-.288T4 12t.288-.712T5 11h11.15L13.3 8.15q-.3-.3-.288-.7t.288-.7q.3-.3.713-.312t.712.287L19.3 11.3q.15.15.213.325t.062.375t-.062.375t-.213.325l-4.575 4.575q-.3.3-.712.288t-.713-.313q-.275-.3-.288-.7t.288-.7z"/></svg>
              </template>
              <template x-if="appCustomer.modalLoading">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="none" stroke="currentColor" stroke-dasharray="16" stroke-dashoffset="16" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3c4.97 0 9 4.03 9 9"><animate fill="freeze" attributeName="stroke-dashoffset" dur="0.2s" values="16;0"/><animateTransform attributeName="transform" dur="1.5s" repeatCount="indefinite" type="rotate" values="0 12 12;360 12 12"/></path></svg>
              </template>
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
      
    </div>

    <script>
      window.shopId = 264248;
      window.apiBaseUrl = "https://api-internal-3.sellauth.com/";
      window.currencyRatesUsd = {"usd":1,"aed":3.673,"afn":64.499991,"all":81.4,"amd":360.3,"ang":1.79,"aoa":917,"ars":1538.49315,"aud":1.421739,"awg":1.8025,"azn":1.7,"bam":1.755348,"bbd":2,"bdt":124.150743,"bgn":1.751144,"bhd":0.37735,"bif":3000.75,"bmd":1,"bnd":1.281553,"bob":11.889313,"brl":5.4165,"bsd":1,"btc":0.000012376084454400318,"btn":95.207377,"bwp":13.822349,"byn":2.947868,"bzd":2.01121,"cad":1.397635,"cdf":2315,"chf":0.826088,"clf":0.025054,"clp":989.26,"cnh":6.656574,"cny":6.6622,"cop":3176.75,"crc":454.761814,"cuc":1,"cup":25.75,"cve":99.2,"czk":21.800606,"djf":178.75,"dkk":6.69201,"dop":60.65,"dzd":135.334009,"egp":56.0252,"ern":15,"etb":161.25,"eur":0.895323,"fjd":2.2432,"fkp":0.748024,"gbp":0.748024,"gel":2.595,"ggp":0.748024,"ghs":11.65,"gip":0.748024,"gmd":74.000005,"gnf":8800,"gtq":7.645879,"gyd":209.614106,"hkd":7.84605,"hnl":26.999999,"hrk":6.746022,"htg":131.05426,"huf":327.196805,"idr":18163.829136,"ils":3.1089,"imp":0.748024,"inr":95.214343,"iqd":1515,"irr":1374600,"isk":121.7,"jep":0.748024,"jmd":158.760372,"jod":0.709,"jpy":157.90442857,"kes":129.95,"kgs":87.448,"khr":4075.5,"kmf":442,"kpw":900,"krw":1339.010746,"kwd":0.310945,"kyd":0.833326,"kzt":453.316618,"lak":22525,"lbp":89550,"lkr":332.450777,"lrd":170.239974,"lsl":16.67,"lyd":6.43,"mad":9.853,"mdl":17.890777,"mga":4590,"mkd":55.229908,"mmk":2099.95,"mnt":3599,"mop":8.082338,"mru":40.2,"mur":47.480002,"mvr":15.46,"mwk":1737,"mxn":18.844665,"myr":4.0597,"mzn":63.899993,"nad":16.67,"ngn":1345.8,"nio":36.8,"nok":9.260514,"npr":152.332162,"nzd":1.776399,"omr":0.384498,"pab":1,"pen":3.452,"pgk":4.4899,"php":63.722509,"pkr":276.65,"pln":3.929615,"pyg":5858.957561,"qar":3.64525,"ron":4.782,"rsd":105.223,"rub":81.243863,"rwf":1477.5,"sar":3.754101,"sbd":8.064705,"scr":13.827096,"sdg":601.5,"sek":9.85393,"sgd":1.28031,"shp":0.748024,"sle":22.95,"sll":20969.5,"sos":571.5,"srd":37.6445,"ssp":130.26,"std":22281.8,"stn":21.988674,"svc":8.749697,"syp":13002,"szl":16.62,"thb":33.7205,"tjs":9.190174,"tmt":3.51,"tnd":3.00825,"top":2.40776,"try":49.837297,"ttd":6.779691,"twd":32.561301,"tzs":2643.773,"uah":45.55389,"ugx":4360.13846,"uyu":40.22581,"uzs":11990,"ves":887.007017,"vnd":25823.112115,"vuv":118.43,"wst":2.7509,"xaf":587.293521,"xag":0.01921783,"xau":0.00024955,"xcd":2.70255,"xcg":1.802288,"xdr":0.732916,"xof":587.293521,"xpd":0.00099199,"xpf":106.840477,"xpt":0.0006752,"yer":236.175059,"zar":16.627542,"zmw":20.200416,"zwg":26.688,"zwl":322,"ltc":0.017328019407381736,"eth":0.000427637346424738,"sol":0.0099000099000099};
      window.defaultCurrency = "USD";
      window.shopCustomer = null;
    </script>

    

    
      <script src="https://dexori.store/assets/themes/altcha@1.5.1.min.js" type="module"></script>
    

    <script
      src="https://cdn.jsdelivr.net/npm/js-cookie@3.0.5/dist/js.cookie.min.js"
      integrity="sha256-WCzAhd2P6gRJF9Hv3oOOd+hFJi/QJbv+Azn4CGB8gfY="
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdn.jsdelivr.net/npm/choices.js@10.2.0/public/assets/scripts/choices.min.js"
      integrity="sha256-P+JgcxEeZtxwYS1+TAAuusKFM646SB8Oodk0TYu9zuo="
      crossorigin="anonymous"
    ></script>
    <script
      src="https://dexori.store/assets/274589/script.js?v=1787771909597"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdn.jsdelivr.net/npm/alpinejs@3.14.3/dist/cdn.min.js"
      integrity="sha256-aJ9ROXjRHWn00zeU9ylsmlhqLlXeebtEfN28P0dPnwc="
      crossorigin="anonymous"
    ></script>

    






  <script defer src="https://a.sellauth.com/script.js" data-website-id="dfe06ae2-004d-486b-98f9-7f4d1afb0d6a"></script>



  </body>
</html>