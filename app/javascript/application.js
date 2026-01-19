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

  // CV Drag and Drop functionality
  function setupDropZone(dropZoneId, fileInputId, fileNameId) {
    const dropZone = document.getElementById(dropZoneId);
    const fileInput = document.getElementById(fileInputId);
    const fileName = document.getElementById(fileNameId);

    if (dropZone && fileInput) {
      // Click to open file picker
      dropZone.addEventListener('click', () => {
        fileInput.click();
      });

      // Prevent default drag behaviors
      ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        dropZone.addEventListener(eventName, preventDefaults, false);
      });

      function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
      }

      // Highlight drop zone when dragging over it
      ['dragenter', 'dragover'].forEach(eventName => {
        dropZone.addEventListener(eventName, () => {
          dropZone.classList.add('drag-over');
        }, false);
      });

      ['dragleave', 'drop'].forEach(eventName => {
        dropZone.addEventListener(eventName, () => {
          dropZone.classList.remove('drag-over');
        }, false);
      });

      // Handle dropped files
      dropZone.addEventListener('drop', (e) => {
        const files = e.dataTransfer.files;
        if (files.length > 0) {
          handleFile(files[0]);
        }
      }, false);

      // Handle file selection via input
      fileInput.addEventListener('change', (e) => {
        if (e.target.files.length > 0) {
          handleFile(e.target.files[0]);
        }
      });

      function handleFile(file) {
        if (file.type === 'application/pdf') {
          if (fileName) {
            fileName.textContent = `Selected: ${file.name}`;
          }
          // Set the file to the input
          const dataTransfer = new DataTransfer();
          dataTransfer.items.add(file);
          fileInput.files = dataTransfer.files;
        } else {
          alert('Please upload a PDF file only.');
          if (fileName) {
            fileName.textContent = '';
          }
        }
      }
    }
  }

  // Setup drop zones
  setupDropZone('cvDropZone', 'cvFileInput', 'fileName');
  setupDropZone('modalCvDropZone', 'modalCvFileInput', 'modalFileName');

  // Modal functionality
  const modal = document.getElementById('applicationModal');
  const modalClose = document.querySelector('.modal-close');
  const expressInterestBtns = document.querySelectorAll('.express-interest-btn');
  const modalTitle = document.getElementById('modalTitle');
  const modalMandateId = document.getElementById('modalMandateId');
  const applicationForm = document.getElementById('applicationForm');

  // Open modal when Express Interest is clicked
  expressInterestBtns.forEach(btn => {
    btn.addEventListener('click', function() {
      const mandateId = this.getAttribute('data-mandate-id');
      const jobTitle = this.closest('.job-card').querySelector('h4').textContent;

      modalTitle.textContent = `Apply for ${jobTitle}`;
      modalMandateId.value = mandateId;
      modal.classList.add('show');
      document.body.style.overflow = 'hidden';
    });
  });

  // Close modal when X is clicked
  if (modalClose) {
    modalClose.addEventListener('click', () => {
      modal.classList.remove('show');
      document.body.style.overflow = 'auto';
      applicationForm.reset();
      document.getElementById('modalFileName').textContent = '';
    });
  }

  // Close modal when clicking outside
  window.addEventListener('click', (e) => {
    if (e.target === modal) {
      modal.classList.remove('show');
      document.body.style.overflow = 'auto';
      applicationForm.reset();
      document.getElementById('modalFileName').textContent = '';
    }
  });

  // Handle form submission
  if (applicationForm) {
    applicationForm.addEventListener('submit', async (e) => {
      e.preventDefault();

      const formData = new FormData(applicationForm);
      const mandateId = modalMandateId.value;
      const submitBtn = applicationForm.querySelector('.modal-submit');
      const originalBtnText = submitBtn.textContent;

      // Show loading state
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<span class="spinner"></span> Submitting...';

      // Get CSRF token
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      try {
        const response = await fetch(`/mandates/${mandateId}/apply`, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': csrfToken
          },
          body: formData
        });

        const result = await response.json();

        if (result.success) {
          // Show success message
          submitBtn.innerHTML = '✓ Application Sent!';
          submitBtn.style.background = 'linear-gradient(135deg, #28a745 0%, #20c997 100%)';

          // Close modal after 2 seconds
          setTimeout(() => {
            modal.classList.remove('show');
            document.body.style.overflow = 'auto';
            applicationForm.reset();
            document.getElementById('modalFileName').textContent = '';
            submitBtn.innerHTML = originalBtnText;
            submitBtn.disabled = false;
            submitBtn.style.background = '';
          }, 2000);
        } else {
          submitBtn.innerHTML = originalBtnText;
          submitBtn.disabled = false;
          alert('Error: ' + (result.errors ? result.errors.join(', ') : 'Something went wrong'));
        }
      } catch (error) {
        submitBtn.innerHTML = originalBtnText;
        submitBtn.disabled = false;
        alert('Error submitting application. Please try again.');
        console.error('Error:', error);
      }
    });
  }
});
