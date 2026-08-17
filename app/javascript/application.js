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

      // Try to find job title from job-card or mandate header
      let jobTitle = 'Position';
      const jobCard = this.closest('.job-card');
      if (jobCard) {
        jobTitle = jobCard.querySelector('h4').textContent;
      } else {
        const mandateHeader = document.querySelector('.mandate-header h1');
        if (mandateHeader) {
          jobTitle = mandateHeader.textContent;
        }
      }

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
      const modalContent = document.querySelector('.modal-content');

      // Get CSRF token
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      // Replace modal content with loading spinner
      modalContent.innerHTML = `
        <div class="modal-loading">
          <div class="spinner-large"></div>
          <p>Submitting your application...</p>
        </div>
      `;

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
          // Replace spinner with success message
          modalContent.innerHTML = `
            <div class="modal-success">
              <div class="success-icon">✓</div>
              <h2>Application Submitted!</h2>
              <p>Thank you for your interest. If there is a match, we will reach out to you.</p>
              <button class="btn-primary modal-done">Done</button>
            </div>
          `;

          // Add event listener to close button
          const doneBtn = modalContent.querySelector('.modal-done');
          doneBtn.addEventListener('click', () => {
            modal.classList.remove('show');
            document.body.style.overflow = 'auto';

            // Restore original modal content
            location.reload();
          });
        } else {
          // Show error and restore form
          modalContent.innerHTML = `
            <div class="modal-error">
              <h2>Error</h2>
              <p>${result.errors ? result.errors.join(', ') : 'Something went wrong. Please try again.'}</p>
              <button class="btn-primary modal-retry">Try Again</button>
            </div>
          `;

          const retryBtn = modalContent.querySelector('.modal-retry');
          retryBtn.addEventListener('click', () => {
            location.reload();
          });
        }
      } catch (error) {
        // Show error and restore form
        modalContent.innerHTML = `
          <div class="modal-error">
            <h2>Error</h2>
            <p>Error submitting application. Please try again.</p>
            <button class="btn-primary modal-retry">Try Again</button>
          </div>
        `;

        const retryBtn = modalContent.querySelector('.modal-retry');
        retryBtn.addEventListener('click', () => {
          location.reload();
        });
        console.error('Error:', error);
      }
    });
  }

  // Handle CV Upload Form Submission
  const cvForm = document.getElementById('cvForm');
  if (cvForm) {
    cvForm.addEventListener('submit', async function(e) {
      e.preventDefault();

      const formData = new FormData(cvForm);
      const submitBtn = document.getElementById('cvSubmitBtn');
      const originalText = submitBtn.value;

      submitBtn.disabled = true;
      submitBtn.value = 'Submitting...';

      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      try {
        const response = await fetch(cvForm.action, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': csrfToken
          },
          body: formData
        });

        const result = await response.json();

        if (result.success) {
          // Hide form and show success message
          document.getElementById('cvFormContent').style.display = 'none';
          document.getElementById('cvSuccessMessage').style.display = 'block';
        } else {
          alert('Error: ' + (result.errors ? result.errors.join(', ') : 'Something went wrong'));
          submitBtn.value = originalText;
          submitBtn.disabled = false;
        }
      } catch (error) {
        alert('Error submitting form. Please try again.');
        submitBtn.value = originalText;
        submitBtn.disabled = false;
        console.error('Error:', error);
      }
    });
  }

  // Download Report Modal functionality
  const downloadModal = document.getElementById('downloadModal');
  const downloadModalClose = document.getElementById('downloadModalClose');
  const downloadReportBtns = document.querySelectorAll('.download-report-btn');
  const downloadForm = document.getElementById('downloadForm');
  const downloadReportId = document.getElementById('downloadReportId');
  const downloadUrlInput = document.getElementById('downloadUrl');

  // Open download modal when Download button is clicked
  if (downloadReportBtns) {
    downloadReportBtns.forEach(btn => {
      btn.addEventListener('click', function() {
        const reportId = this.getAttribute('data-report-id');
        const reportName = this.getAttribute('data-report-name');
        const downloadUrl = this.getAttribute('data-download-url');

        downloadReportId.value = reportId;
        downloadUrlInput.value = downloadUrl;

        downloadModal.classList.add('show');
        document.body.style.overflow = 'hidden';
      });
    });
  }

  // Close download modal when X is clicked
  if (downloadModalClose) {
    downloadModalClose.addEventListener('click', () => {
      downloadModal.classList.remove('show');
      document.body.style.overflow = 'auto';
      downloadForm.reset();
    });
  }

  // Close download modal when clicking outside
  window.addEventListener('click', (e) => {
    if (e.target === downloadModal) {
      downloadModal.classList.remove('show');
      document.body.style.overflow = 'auto';
      downloadForm.reset();
    }
  });

  // Standard Terms Modal functionality
  const termsModal = document.getElementById('termsModal');
  const termsModalClose = document.getElementById('termsModalClose');
  const termsLink = document.getElementById('termsLink');

  // Open terms modal when link is clicked
  if (termsLink) {
    termsLink.addEventListener('click', (e) => {
      e.preventDefault();
      termsModal.classList.add('show');
      document.body.style.overflow = 'hidden';
    });
  }

  // Close terms modal when X is clicked
  if (termsModalClose) {
    termsModalClose.addEventListener('click', () => {
      termsModal.classList.remove('show');
      document.body.style.overflow = 'auto';
    });
  }

  // Close terms modal when clicking outside
  window.addEventListener('click', (e) => {
    if (e.target === termsModal) {
      termsModal.classList.remove('show');
      document.body.style.overflow = 'auto';
    }
  });

  // Handle download form submission
  if (downloadForm) {
    downloadForm.addEventListener('submit', async (e) => {
      e.preventDefault();

      const formData = new FormData(downloadForm);
      const submitBtn = document.getElementById('downloadSubmitBtn');
      const originalText = submitBtn.value;
      const downloadUrl = downloadUrlInput.value;

      submitBtn.disabled = true;
      submitBtn.value = 'Downloading...';

      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      try {
        // Submit the form data to track the download
        const response = await fetch('/compensation_reports/download', {
          method: 'POST',
          headers: {
            'X-CSRF-Token': csrfToken,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            report_id: formData.get('report_id'),
            name: formData.get('name'),
            email: formData.get('email'),
            compensation_details: formData.get('compensation_details')
          })
        });

        const result = await response.json();

        if (result.success) {
          // Trigger the download
          window.open(downloadUrl, '_blank');

          // Close modal and reset form
          downloadModal.classList.remove('show');
          document.body.style.overflow = 'auto';
          downloadForm.reset();
          submitBtn.value = originalText;
          submitBtn.disabled = false;
        } else {
          alert('Error: ' + (result.errors ? result.errors.join(', ') : 'Something went wrong'));
          submitBtn.value = originalText;
          submitBtn.disabled = false;
        }
      } catch (error) {
        alert('Error submitting form. Please try again.');
        submitBtn.value = originalText;
        submitBtn.disabled = false;
        console.error('Error:', error);
      }
    });
  }
});

import "trix"
import "@rails/actiontext"
