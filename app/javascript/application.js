// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Scroll Animation and Navigation
document.addEventListener('turbo:load', function() {
  // Intersection Observer for section animations
  const observerOptions = {
    threshold: 0.15,
    rootMargin: '0px 0px -100px 0px'
  };

  const sectionObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
      }
    });
  }, observerOptions);

  // Observe all sections with animation class
  document.querySelectorAll('.section-animate').forEach(section => {
    sectionObserver.observe(section);
  });

  // Navigation active state tracking
  const navLinks = document.querySelectorAll('.nav-link');
  const sections = document.querySelectorAll('section[id]');

  const navObserverOptions = {
    threshold: 0.5,
    rootMargin: '-50px 0px -50px 0px'
  };

  const navObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const sectionId = entry.target.getAttribute('id');

        // Remove active class from all nav links
        navLinks.forEach(link => {
          link.classList.remove('active');
        });

        // Add active class to current section's nav link
        const activeLink = document.querySelector(`.nav-link[data-section="${sectionId}"]`);
        if (activeLink) {
          activeLink.classList.add('active');
        }
      }
    });
  }, navObserverOptions);

  // Observe all sections for navigation
  sections.forEach(section => {
    navObserver.observe(section);
  });

  // Smooth scroll for navigation links
  navLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault();
      const targetId = link.getAttribute('href').substring(1);
      const targetSection = document.getElementById(targetId);

      if (targetSection) {
        targetSection.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });

  // Add parallax effect to hero section
  let ticking = false;

  window.addEventListener('scroll', () => {
    if (!ticking) {
      window.requestAnimationFrame(() => {
        const scrolled = window.pageYOffset;
        const hero = document.querySelector('.hero');

        if (hero && scrolled < hero.offsetHeight) {
          hero.style.transform = `translateY(${scrolled * 0.5}px)`;
          hero.style.opacity = 1 - (scrolled / hero.offsetHeight) * 0.5;
        }

        ticking = false;
      });

      ticking = true;
    }
  });

  // Remove 3D tilt effect - relying on CSS transitions only for cleaner animations
});
