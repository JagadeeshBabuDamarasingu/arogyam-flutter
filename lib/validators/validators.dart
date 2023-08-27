import 'package:flutter/widgets.dart';

class FormInputFieldValidator {
  // no public instances allowed
  FormInputFieldValidator._();

  static FormFieldValidator compose(List<FormFieldValidator> validators) {
    return (valueCandidate) {
      for (var validator in validators) {
        final validatorResult = validator.call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }
      return null;
    };
  }

  static FormFieldValidator required({String? errorText}) {
    return (valueCandidate) {
      if (valueCandidate == null || (valueCandidate.trim().isEmpty)) {
        return errorText ?? 'this field is required';
      }
      return null;
    };
  }

  static FormFieldValidator exactLength({
    required int length,
    String? errorText,
  }) {
    return (valueCandidate) {
      if (valueCandidate == null || valueCandidate.length != length) {
        return errorText ?? 'should be exactly $length characters long';
      }
      return null;
    };
  }

  static FormFieldValidator minLength({
    required int minLength,
    String? errorText,
  }) {
    return (valueCandidate) {
      if (valueCandidate == null || valueCandidate.length < minLength) {
          return errorText ?? 'should be at-least $minLength characters long';
      }
      return null;
    };
  }

  static FormFieldValidator maxLength({
    required int maxLength,
    String? errorText,
  }) {
    return (valueCandidate) {
      if (valueCandidate == null || valueCandidate.length > maxLength) {
        return errorText ?? 'should be at-most $maxLength characters long';
      }
      return null;
    };
  }
}
